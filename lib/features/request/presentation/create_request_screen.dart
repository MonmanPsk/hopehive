import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/models/request.dart';
import 'package:hopehive/core/services/requests_firestore_service.dart';
import 'package:hopehive/features/request/domain/create_request_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateRequestScreen extends ConsumerWidget {
  CreateRequestScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();

  final _selectorErrorNotifier = ValueNotifier<String?>(null);
  final _contactErrorNotifier = ValueNotifier<String?>(null);
  final options = [
    {'label': 'Delivery', 'icon': Icons.local_shipping_rounded},
    {'label': 'Pickup', 'icon': Icons.directions_car_rounded},
    {'label': 'Any', 'icon': Icons.compare_arrows_rounded},
  ];

  Future<bool> _checkPermission() async {
    if (await Permission.photos.isPermanentlyDenied ||
        await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted;
  }

  Future<void> _pickMultipleImages(WidgetRef ref) async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      ref.read(imageProvider.notifier).state = [
        ...ref.read(imageProvider.notifier).state,
        ...pickedFiles.map((file) => File(file.path))
      ];
    }
  }

  void _showSelectorDialog({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String? selectedItem,
    required Function(String) onItemSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(item),
                      ),
                      trailing: selectedItem == item
                          ? Icon(Icons.check,
                              color: Theme.of(context).primaryColor)
                          : null,
                      onTap: () {
                        onItemSelected(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInputDialog({
    required BuildContext context,
    required String title,
    required Function(String) onSubmitted,
  }) {
    final controller = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter $title',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Form(
            key: dialogFormKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                controller: controller,
                keyboardType: title == 'Phone Number'
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter $title here',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$title cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (dialogFormKey.currentState!.validate()) {
                  onSubmitted(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imageProvider);
    final quantity = ref.watch(quantityProvider);
    final selectedCategory = ref.watch(categoryProvider);
    final categories = ref.watch(categoryListProvider);
    final selectedconditionPreference = ref.watch(conditionPreferenceProvider);
    final conditionPreferences = ref.watch(conditionPreferenceListProvider);
    final selectedUrgency = ref.watch(urgencyProvider);
    final selectedDeliveryOption = ref.watch(deliveryOptionProvider);
    final contactInfo = ref.watch(contactInfoProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Request',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Description Fields
                    ..._buildTextField(context, 'Title', 'Title your donation',
                        _titleController),
                    ..._buildTextField(context, 'Description',
                        'Describe your donation', _reasonController,
                        maxLines: 5),

                    // Images Section
                    ..._buildSectionTitle(context, 'Images (Optional)'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (await _checkPermission()) {
                              _pickMultipleImages(ref);
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permission denied for photos'),
                                ),
                              );
                            }
                          },
                          child: _buildUploadImageBox(),
                        ),
                        ...images.map(
                          (image) => GestureDetector(
                            onTap: () => _showFullImage(context, image),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                image,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Category Selector
                    _buildDropdown(
                      context: context,
                      title: 'Category',
                      selectedItem: selectedCategory,
                      items: categories,
                      onTap: () => _showSelectorDialog(
                        context: context,
                        title: 'Select Category',
                        items: categories,
                        selectedItem: selectedCategory,
                        onItemSelected: (value) =>
                            ref.read(categoryProvider.notifier).state = value,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Condition Preference Selector
                    _buildDropdown(
                      context: context,
                      title: 'Condition Preference',
                      selectedItem: selectedconditionPreference,
                      items: conditionPreferences,
                      onTap: () => _showSelectorDialog(
                        context: context,
                        title: 'Select Condition Preference',
                        items: conditionPreferences,
                        selectedItem: selectedconditionPreference,
                        onItemSelected: (value) => ref
                            .read(conditionPreferenceProvider.notifier)
                            .state = value,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _selectorErrorNotifier,
                      builder: (context, error, child) {
                        return error != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Text(
                                  error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 20),

                    // Quantity Selector
                    ..._buildQuantitySelector(
                        context, ref, quantity, primaryColor),

                    // Urgency Selector
                    ..._buildUrgencySelector(context, ref, selectedUrgency),

                    // Location
                    Row(
                      children: [
                        Text(
                          'Location',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Pickup/Drop-off Option
                    ..._buildSectionTitle(context, 'Pickup/Drop-off Option'),
                    _buildOptionSelector(
                        context, ref, selectedDeliveryOption, primaryColor),

                    const SizedBox(height: 20),

                    // Contact Info Section
                    _buildContactInfoSection(
                        context, ref, contactInfo, primaryColor),
                    ValueListenableBuilder(
                      valueListenable: _contactErrorNotifier,
                      builder: (context, error, child) {
                        return error != null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomSheet(context, ref, primaryColor, images,
          selectedCategory, selectedconditionPreference, contactInfo),
      resizeToAvoidBottomInset: false,
    );
  }

  // Helper methods for UI components
  List<Widget> _buildTextField(BuildContext context, String label, String hint,
      TextEditingController controller,
      {int maxLines = 1}) {
    return [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> _buildSectionTitle(BuildContext context, String title) {
    return [
      Text(title, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 8),
    ];
  }

  Widget _buildUploadImageBox() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.file_upload_outlined, color: Colors.teal, size: 24),
          SizedBox(height: 4),
          Text(
            'Upload Image',
            style: TextStyle(color: Colors.teal, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String title,
    required String? selectedItem,
    required List<String> items,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItem ?? 'Select $title',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: selectedItem == null
                            ? Colors.grey[400]
                            : Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(width: 5),
                Icon(Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildQuantitySelector(
      BuildContext context, WidgetRef ref, int quantity, Color primaryColor) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quantity Needed',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 10),
          Container(
            clipBehavior: Clip.antiAlias,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => ref
                        .read(quantityProvider.notifier)
                        .update((state) => state + 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.add, color: primaryColor, size: 22),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => ref
                        .read(quantityProvider.notifier)
                        .update((state) => state - 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.remove, color: primaryColor, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> _buildUrgencySelector(
      BuildContext context, WidgetRef ref, String selectedUrgency) {
    final Map<String, Color> urgencyColors = {
      "Flexible": Theme.of(context).primaryColor,
      "Soon": Colors.amber,
      "Urgent": const Color(0xFFF94449),
    };

    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Urgency Level", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 10),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: urgencyColors[selectedUrgency]!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedUrgency,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: urgencyColors[selectedUrgency],
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                onChanged: (String? newValue) {
                  ref.read(urgencyProvider.notifier).state = newValue!;
                },
                items: urgencyColors.keys.map((String urgency) {
                  return DropdownMenuItem<String>(
                    value: urgency,
                    child: Text(
                      urgency,
                      style: TextStyle(color: urgencyColors[urgency]),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }

  Widget _buildOptionSelector(BuildContext context, WidgetRef ref,
      String selectedOption, Color primaryColor) {
    return Row(
      children: options.map((option) {
        final isSelected = selectedOption == option['label'];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(deliveryOptionProvider.notifier).state =
                  option['label'] as String;
            },
            child: Container(
              margin: option['label'] == 'Any'
                  ? null
                  : const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color:
                    isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    option['icon'] as IconData,
                    color: isSelected ? primaryColor : Colors.grey,
                    size: 25,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option['label'] as String,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected ? primaryColor : Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactInfoSection(BuildContext context, WidgetRef ref,
      List<Map<String, String?>> contactInfo, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Info', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showContactOptions(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: primaryColor, size: 20),
              const SizedBox(width: 5),
              Text(
                'Add contact',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: primaryColor),
              ),
            ],
          ),
        ),
        if (contactInfo.isNotEmpty)
          ...contactInfo.map(
            (contact) => ListTile(
              title: Text(
                contact['method']!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: primaryColor),
              ),
              subtitle: contact['value'] != null
                  ? Text(contact['value']!,
                      style: Theme.of(context).textTheme.bodyLarge)
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () {
                  ref.read(contactInfoProvider.notifier).state =
                      contactInfo.where((c) => c != contact).toList();
                },
              ),
            ),
          ),
      ],
    );
  }

  void _showContactOptions(BuildContext context, WidgetRef ref) {
    void addContact(String method, {String? value}) {
      ref.read(contactInfoProvider.notifier).state = [
        ...ref.read(contactInfoProvider.notifier).state,
        {'method': method, 'value': value}
      ];
    }

    void handleContactOption(String method) {
      if (method == 'Chat') {
        addContact('Chat');
        Navigator.pop(context);
      } else {
        _showInputDialog(
          context: context,
          title: method == 'Phone' ? 'Phone Number' : 'Email',
          onSubmitted: (value) {
            addContact(method, value: value);
          },
        );
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final contactOptions = ['Chat', 'Phone', 'Email'];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: contactOptions.map((option) {
              return ListTile(
                title: Text(option,
                    style: Theme.of(context).textTheme.titleMedium),
                onTap: () => handleContactOption(option),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<String> uploadImage(String filePath) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child("request_images/$fileName");
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  Widget _buildBottomSheet(
      BuildContext context,
      WidgetRef ref,
      Color primaryColor,
      List<File> images,
      String? selectedCategory,
      String? selectedconditionPreference,
      List<Map<String, String?>> contactInfo) {
    final isLoading = ref.watch(isLoadingProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  bool isValid = true;

                  // Validate selectors
                  if (selectedCategory == null ||
                      selectedconditionPreference == null) {
                    _selectorErrorNotifier.value =
                        'Please select both category and item condition.';
                    isValid = false;
                  } else {
                    _selectorErrorNotifier.value = null;
                  }

                  // Validate contact info
                  if (contactInfo.isEmpty) {
                    _contactErrorNotifier.value =
                        'Please add at least one contact method.';
                    isValid = false;
                  } else {
                    _contactErrorNotifier.value = null;
                  }

                  // Validate form fields
                  if (_formKey.currentState!.validate() && isValid) {
                    ref.read(isLoadingProvider.notifier).state = true;

                    try {
                      // Upload images to Firebase Storage
                      List<String> uploadedImageUrls = await Future.wait(images
                          .map((imagePath) => uploadImage(imagePath.path)));

                      DocumentReference requestRef = FirebaseFirestore.instance
                          .collection('requests')
                          .doc();

                      // Retrieve form values
                      final title = _titleController.text.trim();
                      final reason = _reasonController.text.trim();
                      final category = selectedCategory;
                      final condition = selectedconditionPreference;
                      final location = ref.read(locationProvider);
                      final option = ref.watch(deliveryOptionProvider);
                      final quantity = ref.watch(quantityProvider);
                      final contactInfo = ref.watch(contactInfoProvider);

                      // Create request document
                      Request request = Request(
                        requestId: requestRef.id,
                        creator: FirebaseAuth.instance.currentUser!.uid,
                        donors: [],
                        title: title,
                        reason: reason,
                        images: uploadedImageUrls,
                        category: category!,
                        condition: condition!,
                        quantity: quantity,
                        urgency: ref.watch(urgencyProvider),
                        location: location!,
                        option: option,
                        contact: contactInfo,
                        createdAt: Timestamp.now(),
                      );
                      await RequestsFirestoreService().addRequest(request);

                      // Add request ID to user's request list
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({
                        'donation': FieldValue.arrayUnion([requestRef.path]),
                      });

                      // Close the form
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Failed to create donation: $e")),
                      );
                    } finally {
                      ref.read(isLoadingProvider.notifier).state = false;
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Create'),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.file(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
