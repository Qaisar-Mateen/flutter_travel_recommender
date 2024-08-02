import "package:flutter/material.dart";
import 'package:travel_recommender/pages/settings.dart';

class Login extends StatelessWidget {
  
  const Login({super.key});
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
          },
        ),]
      ),
      body: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15), 
            child: Text("S I G N I N"),
            ),
        ),
      ),
    );
  }

}