// ignore_for_file: use_build_context_synchronously
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:travel_recommender/pages/home.dart';
import 'package:travel_recommender/pages/settings.dart';
import 'package:travel_recommender/settings_cubit.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController idController = TextEditingController();
  bool isFetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
        },
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Icon(Icons.account_circle, size: 100),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: "Enter ID",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isFetching? null : () async {
                            final String id = idController.text;
                            if (id.isNotEmpty) {
                              setState(() {isFetching = true;});
                              try {
                                final response = await http.get(Uri.parse(
                                        '''http://${context.read<ServerCubit>().state.ip}:
                                        ${context.read<ServerCubit>().state.port}/login?userId=$id'''))
                                    .timeout(Duration(seconds: int.parse(context.read<ServerCubit>().state.timeout)));
                                if (response.statusCode == 200) {
                                  if (mounted) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(id: int.parse(id))));
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Invalid User ID", textAlign: TextAlign.center),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Something is wrong with the server", textAlign: TextAlign.center)
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isFetching = false;
                                  });
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your ID", textAlign: TextAlign.center)
                                ),
                              );
                            }
                          },
                    child: isFetching? const Text("Verifying...") : const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}