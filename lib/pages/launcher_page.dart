import 'package:firebase_batch6/pages/login_page.dart';
import 'package:firebase_batch6/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../auth/firebase_auth.dart';
import 'user_list_page.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override
  void initState() {

    Future.delayed(Duration.zero,(){
      if(AuthService.user==null){
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
      else{
        Navigator.pushReplacementNamed(context, UserListPage.routeName);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
