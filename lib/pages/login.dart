import "package:flutter/material.dart";
import 'package:travel_recommender/pages/settings.dart';

class Login extends StatelessWidget {
  
  const Login({super.key});
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    return  Scaffold(
      appBar: AppBar(
        actions: [IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
          },
        ),]
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  
                  const Padding(
                    padding: EdgeInsets.only(top:10),
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
                    onPressed: () {
                      final String id = idController.text;
                      if (id.isNotEmpty) {
                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your ID"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            //margin: EdgeInsets.symmetric(horizontal: 5),
                            
                            shape: StadiumBorder()
                          ),
                        );
                      }
                    },
                    child: const Text("Login"),
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