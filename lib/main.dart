import 'package:firebase_batch6/auth/firebase_auth.dart';
import 'package:firebase_batch6/pages/chat_room_page.dart';
import 'package:firebase_batch6/pages/login_page.dart';
import 'package:firebase_batch6/providers/chat_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'pages/launcher_page.dart';
import 'pages/profile_page.dart';
import 'pages/user_list_page.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(AuthService.user != null) {
      Provider.of<UserProvider>(context, listen: false)
          .updateProfile(AuthService.user!.uid, {'available' : true});
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused) {
      if(AuthService.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available' : false});
      }
    } else if(state == AppLifecycleState.resumed) {
      if(AuthService.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available' : true});
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => LauncherPage(),
        LoginPage.routeName: (_) => LoginPage(),
        ProfilePage.routeName: (_) => ProfilePage(),
        ChatRoomPage.routeName: (_) => ChatRoomPage(),
        UserListPage.routeName: (_) => UserListPage(),
      },
    );
  }
}
