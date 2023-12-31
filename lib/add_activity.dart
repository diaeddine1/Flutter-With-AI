import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite_v2/tflite_v2.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({Key? key}) : super(key: key);

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var categories = "";
  TextEditingController Title = TextEditingController();
  TextEditingController lieu = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController nbr_minimal = TextEditingController();
  TextEditingController urlimage = TextEditingController();
  TextEditingController category_prediction = TextEditingController();

  @override
  void initState() {
    super.initState();
    ModelLoad().then((value) {
      setState(() {});
    });
  }

  ModelLoad() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
        urlimage.text = _image?.path ?? '';
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> detectimage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      categories = _recognitions[0]["label"];
      category_prediction.text = categories;
    });
    print(_recognitions);
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  void clearFields() {
    Title.clear();
    lieu.clear();
    price.clear();
    nbr_minimal.clear();
    urlimage.clear();
    category_prediction.clear();
    setState(() {
      _image = null;
      file = null;
      _recognitions = null;
      categories = "";
    });
  }

  Future<void> _uploadFile() async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().millisecondsSinceEpoch}.jpg");

      TaskSnapshot taskSnapshot = await storageReference.putFile(File(_image!.path));

      String photoUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> data = {
        "imageUrl": photoUrl,
        "location": lieu.text,
        "price": int.parse(price.text),
        "minPersons": int.parse(nbr_minimal.text),
        "title": Title.text,
        "category": category_prediction.text,
      };

      await FirebaseFirestore.instance.collection("activities").add(data);

      clearFields();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Added The Activity'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print("Failed To Add The Category Due To: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add The Activity"),
        backgroundColor: Color.fromRGBO(85, 105, 254, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              _buildPickImageButton(),
              if (_image != null) _buildInputField("Category", category_prediction, enabled: false),
              _buildInputField("Title", Title),
              _buildInputField("Lieu", lieu),
             
              _buildInputField("Nombre de personne minimum nécessaire", nbr_minimal, inputType: TextInputType.number),
               _buildInputField("Prix", price, inputType: TextInputType.number),
              _buildAddActivityButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: _imagePreviewContent(),
    );
  }

  Widget _imagePreviewContent() {
    return _image != null
        ? Image.file(
            File(_image!.path),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 48.0,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8.0),
                Text(
                  'Aucune Image Sélectionnée',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildPickImageButton() {
    return ElevatedButton(
      onPressed: _pickImage,
      child: Text('Choisir une image de la galerie'),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {TextInputType? inputType, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        enabled: enabled,
        style: TextStyle(color: Colors.black, fontSize: 18.0),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget _buildAddActivityButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          int prix = int.parse(price.text);
          int nbrMin = int.parse(nbr_minimal.text);

          await _uploadFile();
        } catch (e) {
          print("Error adding activity: $e");
        }
      },
      child: Text("Add Your Activity"),
    );
  }
}
