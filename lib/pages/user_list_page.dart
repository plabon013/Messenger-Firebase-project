import 'package:firebase_batch6/auth/firebase_auth.dart';
import 'package:firebase_batch6/providers/user_provider.dart';
import 'package:firebase_batch6/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_item.dart';

class UserListPage extends StatefulWidget {
  static const String routeName = '/user_list';
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if(isFirst) {
      Provider
          .of<UserProvider>(context, listen: false)
          .getAllRemainingUser(AuthService.user!.uid);
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.remainingUserList.length,
          itemBuilder: (context, index) {
            final user = provider.remainingUserList[index];
            return UserItem(userModel: user);
          },
        ),
      ),
    );
  }
}
