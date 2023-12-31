import 'package:flutter/material.dart';

class NAVBAR extends StatelessWidget {
  const NAVBAR({super.key});
  Future <void> Activity(BuildContext context)
  async {
    print("activity clicked");
  }
  Future <void> Add(BuildContext context)
  async {
    print("ajouter clicked");
  }
  Future <void> Profil(BuildContext context)
  async {
    print("profil clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your activities!"),centerTitle: true,),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        
        child: Align(alignment: Alignment.bottomCenter,child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
       
        Container(
          margin:EdgeInsets.all(8) ,
          child: const SizedBox(height: 20)), ElevatedButton(onPressed: ()=>Activity(context), child: const Text("ACTIVITY"),style: ElevatedButton.styleFrom(padding:const EdgeInsets.all(16.0)),),
        
        Container(
          margin: EdgeInsets.all(8),
         // padding: EdgeInsets.all(8),
          child: const SizedBox(height: 20)),
        ElevatedButton(onPressed: ()=>Add(context), child: const Text("AJOUTER"),style: ElevatedButton.styleFrom(padding:const EdgeInsets.all(16.0)),),
        
        Container(margin: EdgeInsets.all(8), child: const SizedBox(height: 20)),
        ElevatedButton(onPressed: ()=>Profil(context), child: const Text("PROFIL"),style: ElevatedButton.styleFrom(padding:const EdgeInsets.all(16.0)),),
        
        
        
        
        ],
        
        
        
        
        
        ),
      ),),

    );
  }
}