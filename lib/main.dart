import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      )
    );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late means i'm going to attribute a value later on
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register")
      ,), 
      // Column means that everything will display in one column
      body: FutureBuilder(
        future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
         return Column(
          children: [
            // Display an empty text field on the screen
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email"
              )
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:  const InputDecoration(
                hintText: 'Enter your password'
              )
            ),
            // Display a text button, child being the content, onPressed is the function
            TextButton(
        
              // Function to create a new user
              onPressed: () async {
        
                final email = _email.text;
                final password = _password.text;
        
                // await because this function return a Future
                final userCredentials = 
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, 
                    password: password
                    );
                    print(userCredentials);
              }, 
              child: const Text('Register')),
          ],
        ); 
        },
      )
    );
  }
}