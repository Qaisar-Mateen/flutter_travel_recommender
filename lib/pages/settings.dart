import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatelessWidget {

  TextEditingController ipAddress = TextEditingController();
  TextEditingController port = TextEditingController();

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S E T T I N G S"), centerTitle: true,),
      body: Column(
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Padding(
              padding: const EdgeInsets.only(top:12, left: 8, right: 8),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Theme Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                  SwitchListTile(
                    title: const Text("Dark Theme"),
                    value: false,
                    onChanged: (bool value) {}
                  )
                ],
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Padding(
              padding: const EdgeInsets.only(top:12, left: 20, right: 20, bottom: 15),
              child: Column( crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  const Text("Server Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                  TextField(
                    controller: ipAddress,
                    decoration: const InputDecoration(
                      labelText: "IP Address",
                    ),
                  ),
                  TextField(
                    controller: port,
                    decoration: const InputDecoration(
                      labelText: "Port",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}