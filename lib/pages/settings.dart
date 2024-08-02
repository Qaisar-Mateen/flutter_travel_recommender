import 'package:flutter/material.dart';

class Settings extends StatelessWidget {

  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S E T T I N G S"), centerTitle: true,),
      body: const Column(
        children: [
          Card(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Theme Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                ListTile()
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Server Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                ListTile()
              ],
            ),
          ),
        ],
      ),
    );
  }
}