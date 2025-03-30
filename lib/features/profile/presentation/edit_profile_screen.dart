import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/providers/user_provider.dart';
import 'package:hopehive/core/services/users_firestore_service.dart';
import 'package:hopehive/features/profile/domain/edit_profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
  final _phoneController = TextEditingController();
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

  Future<void> _uploadProfilePicture(String userId) async {
    if (_imagePathNotifier.value == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final userRef = storageRef.child('profile_pictures/$userId.jpg');

    // Delete old profile picture if it exists
    final user = await UsersFirestoreService().getUser(userId);
    if (user?.profileImage != null) {
      await FirebaseStorage.instance.refFromURL(user!.profileImage!).delete();
    }

    // Upload new profile picture
    final uploadTask = await userRef.putFile(File(_imagePathNotifier.value!));
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    // Update Firestore with the new profile picture URL
    await UsersFirestoreService().updateUser(userId, {
      'profileImage': downloadUrl,
    });
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);
  }

  Future<void> _saveChanges(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser!.uid;

    ref.read(isLoadingProvider.notifier).state = true;

    try {
      await _uploadProfilePicture(userId);

      // Update other user details in Firestore
      await UsersFirestoreService().updateUser(
        userId,
        {
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
        },
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final userAsyncValue =
        ref.watch(userProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final user = userAsyncValue.value;

    if (user != null) {
      _firstNameController.text = user.firstname;
      _lastNameController.text = user.lastname;
      _phoneController.text = user.phone ?? '';
    }

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
                        final currentPhotoURL =
                            FirebaseAuth.instance.currentUser?.photoURL;

                        return CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage: imagePath != null
                              ? FileImage(File(imagePath))
                              : (currentPhotoURL != null
                                  ? NetworkImage(currentPhotoURL)
                                  : null),
                          child: (imagePath == null && currentPhotoURL == null)
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
                            if (!context.mounted) return;
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
                  onPressed:
                      isLoading ? null : () => _saveChanges(context, ref),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
