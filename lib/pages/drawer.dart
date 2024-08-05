import 'package:flutter/material.dart';
import 'package:travel_recommender/pages/login.dart';

class MyDrawer extends StatelessWidget {
  final int id;

  const MyDrawer({required this.id, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Expanded(
        child: Column(
          children: [
            const DrawerHeader(child: Icon(Icons.account_circle, size: 130)),
        
            Padding(padding: const EdgeInsets.only(left: 25, top: 10),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        
            Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(child: const Text('Logout'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (Route<dynamic> route) => false
                );
              },
            ),
          ),
        ],),
      ),
    );
  }
}