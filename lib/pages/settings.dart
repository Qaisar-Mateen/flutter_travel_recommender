import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';

// ignore: must_be_immutable
class Settings extends StatelessWidget {

  TextEditingController ipAddress = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController timeout = TextEditingController();

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
                    child: BlocBuilder<ServerCubit, ServerState>(
                      builder: (context, state) {
                        ipAddress.text = state.ip;
                        return TextField(
                          controller: ipAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "IP Address",
                          ),
                          onChanged: (value) {
                            state.ip = value;
                          },
                        );
                      }
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: BlocBuilder<ServerCubit, ServerState>(
                      builder: (context, state) {
                        port.text = state.port;
                        return TextField(
                          controller: port,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Port",
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            state.port = value;
                          },
                        );
                      }
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: BlocBuilder<ServerCubit, ServerState>(
                      builder: (context, state) {
                        timeout.text = state.timeout;
                        return TextField(
                          controller: timeout,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Timeout",
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            state.timeout = value;
                          },
                        );
                      }
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