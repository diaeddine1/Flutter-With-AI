import 'package:flutter/material.dart';
import 'package:flutterai/homapge.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;

  ActivityDetailPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(activity.title)), 
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300, 
              child: CachedNetworkImage(
                imageUrl: activity.imageUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
              ),
            ),
            Card(
              margin: EdgeInsets.all(16.0),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    SizedBox(height: 12.0),
                    Text(
                      'Location: ${activity.location}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Category: ${activity.category}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Prix: ${activity.price}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                 
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
