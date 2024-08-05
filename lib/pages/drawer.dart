import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  
  const MyDrawer({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        const DrawerHeader(child: Icon(Icons.account_circle, size: 150,)),
          Padding(padding: const EdgeInsets.only(left: 25, top: 10),
          child: ListTile(
            title: const Text("H O M E"),
            leading: const Icon(Icons.home_rounded),
            onTap: () {
              // get back from drawer
              Navigator.pop(context);

              
              //get to Home
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
          )),

          Padding(padding: const EdgeInsets.only(left: 25, top: 10),
          child: ListTile(
            title: const Text("S E T T I N G S"),
            leading: const Icon(Icons.settings_rounded),
            onTap: () {
              // get back from drawer
              Navigator.pop(context);

              //get to Home
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          )),
      ],),
    );
  }
}