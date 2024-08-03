import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';

// ignore: must_be_immutable
class Settings extends StatelessWidget {

  TextEditingController ipAddress = TextEditingController(text: "192.168.1.9");
  TextEditingController port = TextEditingController(text: "5000");

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S E T T I N G S"), centerTitle: true,),
      body: Column(
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Padding(
              padding: const EdgeInsets.only(top:12, left: 8, right: 8),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Theme Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                  BlocBuilder<ThemeCubit, ThemeData>(
                    builder: (context, toggleTheme) {
                      return SwitchListTile(
                        title: const Text("Dark Theme"),
                        value: context.read<ThemeCubit>().isDark(),
                        onChanged: (bool value) {
                          context.read<ThemeCubit>().toggleTheme();
                        }
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 2,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Padding(
              padding: const EdgeInsets.only(top:12, left: 20, right: 20, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  const Text("Server Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(top:30, bottom: 10),
                    child: TextField(
                      controller: ipAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "IP Address",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: port,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Port",
                      ),
                      keyboardType: TextInputType.number,
                    ),
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