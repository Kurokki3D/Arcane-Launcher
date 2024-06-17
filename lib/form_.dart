import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormsOf extends StatelessWidget {
  FormsOf({super.key});

  final formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      print('Username: $username');
      print('Password: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(50),
              color: Colors.transparent,
              height: 150,
              width: 150,
              child: const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/arcane_launcher_icon.png'),
                child: Icon(Icons.person),
              ),
            ),
            Card(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Enter Email'),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                          .hasMatch(value!)) {
                    return 'Enter correct email';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Card(
              child: TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Enter Under cover name'),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                    return 'Only Letters';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Great'),
                      ),
                    );

                    Navigator.pushNamed(context, 'FilesFromFire');
                  }
                },
                child: const Text('Lets go'))
          ],
        ),
      ),
    );
  }
}
