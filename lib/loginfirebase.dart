import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
 // const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();
    return StreamBuilder<User?>(stream: _auth.authStateChanges(), builder: (context,snapshot)
    {
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return CircularProgressIndicator();
      }
      else if(snapshot.hasError)
      {
        return Text("Error:${snapshot.error}");
      }
      else
      {
        final user = snapshot.data;
        if(user==null)
        {
          return Text("Not authenticated");
        }
        else
        {
          return Text("Autheticated user :${user.displayName}");
        }
      }
    });
  }
}