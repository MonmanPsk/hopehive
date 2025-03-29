import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName?.split(' ')[0]);
  final _lastNameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName?.split(' ')[1]);
  final _emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
  final _phoneController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.phoneNumber);
  final ValueNotifier<String?> _imagePathNotifier =
      ValueNotifier<String?>(null);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imagePathNotifier.value = pickedFile.path;
    }
  }

  Future<bool> _checkPermission() async {
    // First, check if the permission is permanently denied
    if (await Permission.photos.isPermanentlyDenied ||
        await Permission.storage.isPermanentlyDenied) {
      // Redirect to app settings
      await openAppSettings();
      return false;
    }

    // Request permissions
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_imagePathNotifier.value != null) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.file(
                                File(_imagePathNotifier.value!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _imagePathNotifier,
                      builder: (context, imagePath, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage: imagePath != null
                              ? FileImage(File(imagePath))
                              : null,
                          child: imagePath == null
                              ? const Icon(
                                  Icons.bubble_chart_rounded,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -3,
                    right: -3,
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        iconSize: 15,
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () async {
                          if (await _checkPermission()) {
                            _pickImage();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Permission denied for photos'),
                              ),
                            );
                          }
                        },
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: const CircleBorder(),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
