import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/features/donate/domain/create_donation_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Test extends ConsumerWidget {
  Test({super.key});

  final options = [
    {'label': 'Pickup', 'icon': Icons.play_for_work_rounded},
    {'label': 'Drop-off', 'icon': Icons.directions_car_rounded},
    {'label': 'Any', 'icon': Icons.compare_arrows_rounded},
  ];
  final ValueNotifier<String?> _imagePathNotifier =
      ValueNotifier<String?>(null);

  Future<bool> _checkPermission() async {
    if (await Permission.photos.isPermanentlyDenied ||
        await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted;
  }

  Future<void> _pickImage(ValueNotifier<String?> notifier) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      notifier.value = pickedFile.path;
    }
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter $title'),
          content: TextField(
            controller: controller,
            keyboardType: title == 'Phone Number'
                ? TextInputType.phone
                : TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSubmitted(controller.text);
                Navigator.pop(context);
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
    final selectedItemCondition = ref.watch(itemConditionProvider);
    final itemConditions = ref.watch(itemConditionListProvider);
    final contactInfo = ref.watch(contactInfoProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Donation',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                if (await _checkPermission()) {
                  _pickImage(_imagePathNotifier);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permission denied for photos'),
                    ),
                  );
                }
              },
              child: ValueListenableBuilder(
                valueListenable: _imagePathNotifier,
                builder: (context, imagePath, child) {
                  return Container(
                    width: double.infinity,
                    height: 160,
                    color: primaryColor.withOpacity(0.1),
                    child: imagePath != null
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: primaryColor,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload your donation banner',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Description Fields
                  ..._buildTextField(context, 'Title', 'Title your donation'),
                  ..._buildTextField(
                      context, 'Description', 'Describe your donation',
                      maxLines: 5),

                  // Images Section
                  _buildSectionTitle(context, 'Images'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (await _checkPermission()) {
                            _pickMultipleImages(ref);
                          } else {
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

                  // Item Condition Selector
                  _buildDropdown(
                    context: context,
                    title: 'Item Condition',
                    selectedItem: selectedItemCondition,
                    items: itemConditions,
                    onTap: () => _showSelectorDialog(
                      context: context,
                      title: 'Select Item Condition',
                      items: itemConditions,
                      selectedItem: selectedItemCondition,
                      onItemSelected: (value) => ref
                          .read(itemConditionProvider.notifier)
                          .state = value,
                    ),
                  ),

                  // Quantity Selector
                  _buildQuantitySelector(context, ref, quantity, primaryColor),

                  // Contact Info Section
                  _buildContactInfoSection(
                      context, ref, contactInfo, primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(context, primaryColor),
      resizeToAvoidBottomInset: false,
    );
  }

  // Helper methods for UI components
  List<Widget> _buildTextField(BuildContext context, String label, String hint,
      {int maxLines = 1}) {
    return [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 8),
      TextField(
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint),
      ),
      const SizedBox(height: 20),
    ];
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.labelLarge);
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
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: 10),
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

  Widget _buildQuantitySelector(
      BuildContext context, WidgetRef ref, int quantity, Color primaryColor) {
    return Row(
      children: [
        Text('Quantity', style: Theme.of(context).textTheme.labelLarge),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Chat',
                    style: Theme.of(context).textTheme.titleMedium),
                onTap: () {
                  ref.read(contactInfoProvider.notifier).state = [
                    ...ref.read(contactInfoProvider.notifier).state,
                    {'method': 'Chat'}
                  ];
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Phone',
                    style: Theme.of(context).textTheme.titleMedium),
                onTap: () {
                  _showInputDialog(
                    context: context,
                    title: 'Phone Number',
                    onSubmitted: (value) {
                      ref.read(contactInfoProvider.notifier).state = [
                        ...ref.read(contactInfoProvider.notifier).state,
                        {'method': 'Phone', 'value': value}
                      ];
                    },
                  );
                },
              ),
              ListTile(
                title: Text('Email',
                    style: Theme.of(context).textTheme.titleMedium),
                onTap: () {
                  _showInputDialog(
                    context: context,
                    title: 'Email',
                    onSubmitted: (value) {
                      ref.read(contactInfoProvider.notifier).state = [
                        ...ref.read(contactInfoProvider.notifier).state,
                        {'method': 'Email', 'value': value}
                      ];
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context, Color primaryColor) {
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
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Create'),
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
