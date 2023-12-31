import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterai/activity_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Activity {
  final String title;
  final String location;
  final String imageUrl;
  final double price;
  final String category;

  Activity({
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  factory Activity.fromFirestore(Map<String, dynamic> data) {
    return Activity(
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
    );
  }
}

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  List<String> _categories = ['All Activities']; 
  String _selectedCategory = 'All Activities'; 

  Future<List<Activity>> _filteredActivitiesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _filterActivitiesByCategory(_selectedCategory);
  }

  Future<void> _fetchCategories() async {
    try {
      var categories = Set<String>();
      var querySnapshot = await FirebaseFirestore.instance.collection('activities').get();

      querySnapshot.docs.forEach((doc) {
        categories.add(doc['category']);
      });

      setState(() {
        _categories = ['All Activities', ...categories.toList()];
      });
    } catch (error) {
      
      print('Error fetching categories: $error');
    }
  }

  Future<List<Activity>> _getAllActivities() async {
    try {
      var activitiesSnapshot = await FirebaseFirestore.instance.collection('activities').get();
      return activitiesSnapshot.docs
          .map((doc) => Activity.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
     
      print('Error fetching activities: $error');
      return [];
    }
  }

  void _filterActivitiesByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredActivitiesFuture = _getAllActivities().then((allActivities) {
        return _selectedCategory == 'All Activities'
            ? allActivities
            : allActivities.where((activity) => activity.category == _selectedCategory).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activités'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              children: _categories.map((category) {
                return ElevatedButton(
                  onPressed: () {
                    _filterActivitiesByCategory(category);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _selectedCategory == category ? Colors.teal : null,
                  ),
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Activity>>(
              future: _filteredActivitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var activities = snapshot.data ?? [];

                if (activities.isEmpty) {
                  return Center(
                    child: Text('Aucune activité trouvée.'),
                  );
                }

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(
                          activities[index].title,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activities[index].location),
                            SizedBox(height: 4.0),
                            Text(
                              'Category: ${activities[index].category}',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: activities[index].imageUrl,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ActivityDetailPage(activity: activities[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
