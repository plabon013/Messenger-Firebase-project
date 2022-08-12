import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_batch6/pages/login_page.dart';
import 'package:firebase_batch6/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../auth/firebase_auth.dart';
import '../models/usermodel.dart';
import '../widgets/main_drawer.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final txtController = TextEditingController();
  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: Text('Profile Page'),
        actions: [
          IconButton(onPressed: () {
            AuthService.logOut();
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          }, icon: Icon(Icons.logout))
        ],),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: provider.getUserById(AuthService.user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userModel = UserModel.fromMap(snapshot.data!.data()!);
                    return ListView(
                      children: [
                        Center(
                          child: userModel.image == null ?
                          Image.asset('images/person.png', width: 100,
                            height: 100,
                            fit: BoxFit.cover,) :
                          Image.network(userModel.image!, width: 100,
                            height: 100,
                            fit: BoxFit.cover,),
                        ),
                        ElevatedButton.icon(
                            onPressed: _getImage,
                            icon: const Icon(Icons.camera),
                            label: const Text('Update Image'),
                        ),
                        const Divider(color: Colors.black, height: 1,),
                        ListTile(
                          title: Text(userModel.name ?? 'No Display name'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showInputDialog(
                                  title: 'Display Name',
                                  value: userModel.name,
                                  onSaved: (value) async {
                                provider.updateProfile(AuthService.user!.uid,
                                    {'name' : value});
                                await AuthService.updateDisplayName(value);
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(userModel.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showInputDialog(
                                  title: 'Email',
                                  value: userModel.email,
                                  onSaved: (value) async {
                                    await AuthService.updateEmail(value);
                                    await provider.updateProfile(AuthService.user!.uid,
                                        {'email' : value});
                                  });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(userModel.mobile ?? 'No Mobile Number'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showInputDialog(
                                  title: 'Mobile Number',
                                  value: userModel.mobile,
                                  onSaved: (value) {
                                    provider.updateProfile(AuthService.user!.uid,
                                        {'mobile' : value});
                                  });
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('Failed to fetch Data');
                  }
                  return const CircularProgressIndicator();
                },
              ),
        ),
      ),
    );
  }

  void _getImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 75);
    if(xFile != null) {
      final downloadUrl = await Provider
          .of<UserProvider>(context, listen: false)
          .updateImage(File(xFile.path));
      await Provider
          .of<UserProvider>(context, listen: false)
          .updateProfile(AuthService.user!.uid, {'image' : downloadUrl});
      await AuthService.updatePhotoUrl(downloadUrl);

    }
  }

  showInputDialog({
    required String title,
    String? value, required
    Function(String) onSaved}) {
    txtController.text = value ?? '';
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: txtController,
          decoration: InputDecoration(
            hintText: 'Enter $title'
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            onSaved(txtController.text);
            Navigator.pop(context);
          },
          child: const Text('UPDATE'),
        ),
      ],
    ));
  }
}
