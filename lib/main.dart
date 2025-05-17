import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/screens/home.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:todo_app/screens/login_screen.dart';

void main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'bw0r4fpx6MeTctFt2pMSfOSv0ajtLNHFsotd6V6s';
  const keyClientKey = '5FSpvDKickT327j3SqQg2p6NWhyYsOJ9t6smE3Og';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: FutureBuilder<ParseUser?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data != null) {
            return const Home();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  // A method to safely get the current user with typecasting
  Future<ParseUser?> _getCurrentUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    return user;
  }
}
