import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';

class Settings extends StatelessWidget {
  final TextEditingController ipAddress = TextEditingController();
  final TextEditingController port = TextEditingController();
  final TextEditingController timeout = TextEditingController();

  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S E T T I N G S"), centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:15),
          child: Column(
            children: [
              Card(
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Padding(
                  padding: const EdgeInsets.only(top:12, left: 8, right: 8),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Theme Settings", style: TextStyle(fontWeight: FontWeight.bold),),
                      BlocBuilder<ThemeCubit, ThemeData>(
                        builder: (context, toggleTheme) {
                          return Row(mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 23, bottom: 15, top: 10),
                              child: Text("Dark Theme", style: TextStyle(fontSize: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom:15, top:10, right: 23),
                              child: CupertinoSwitch(
                                activeColor: Colors.blue.shade800,
                                trackColor: const Color.fromARGB(255, 57, 192, 255),
                                dragStartBehavior: DragStartBehavior.down,
                                value: context.read<ThemeCubit>().isDark(),
                               onChanged: (value) {
                                context.read<ThemeCubit>().toggleTheme();
                              }),
                            )
                          ]);
                        }
                      ),
                    ],
                  ),
                ),
              ),
          
              Card(
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Padding(
                  padding: const EdgeInsets.only(top:12, left: 31, right: 31, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      const Text("Server Settings", style: TextStyle(fontWeight: FontWeight.bold),),

                      BlocBuilder<ServerCubit, ServerState>(
                        builder: (context, state) {
                          return Row(mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text("Local Server", style: TextStyle(fontSize: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: CupertinoSwitch(
                                activeColor: Colors.blue.shade800,
                                trackColor: const Color.fromARGB(255, 57, 192, 255),
                                dragStartBehavior: DragStartBehavior.down,
                                value: context.read<ServerCubit>().state.local,
                               onChanged: (value) {
                                context.read<ServerCubit>().switchLocal();
                              }),
                            )
                          ]);
                        }
                      ),
          
                      Padding(
                        padding: const EdgeInsets.only(top:20, bottom: 10),
                        child: BlocBuilder<ServerCubit, ServerState>(
                          builder: (context, state) {
                            ipAddress.text = state.ip;
                            return TextField(
                              enabled: state.local,
                              controller: ipAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "IP Address",
                              ),
                              onSubmitted: (value) {
                                try {
                                  context.read<ServerCubit>().updateText(ip: value);
                                }
                                catch(e) {
                                  ipAddress.text = state.ip;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("$e", textAlign: TextAlign.center),)
                                  );
                                }
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
                              enabled: state.local,
                              controller: port,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Port",
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                try {
                                  context.read<ServerCubit>().updateText(port: value);
                                }
                                catch (e) {
                                  port.text = state.port;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$e", textAlign: TextAlign.center)
                                    )
                                  );
                                }
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
                              onSubmitted: (value) {
                                try {
                                  context.read<ServerCubit>().updateText(timeout: value);
                                }
                                catch (e) {
                                  timeout.text = state.timeout;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$e", textAlign: TextAlign.center)
                                    )
                                  );
                                }
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
        ),
      ),
    );
  }
}