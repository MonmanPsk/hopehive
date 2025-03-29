import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/features/donate/domain/create_donation_provider.dart';

class CreateDonationScreen extends ConsumerWidget {
  const CreateDonationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider);
    final selectedPickupOption = ref.watch(pickupOptionProvider);
    final selectedRecipientMethod = ref.watch(recipientMethodProvider);
    final selectedCategory = ref.watch(categoryProvider);
    final categories = ref.watch(categoryListProvider);
    final selectedItemCondition = ref.watch(itemConditionProvider);
    final itemConditions = ref.watch(itemConditionListProvider);
    final options = [
      {'label': 'Pickup', 'icon': Icons.play_for_work_rounded},
      {'label': 'Drop-off', 'icon': Icons.directions_car_rounded},
      {'label': 'Any', 'icon': Icons.compare_arrows_rounded},
    ];

    final Color primaryColor = Theme.of(context).primaryColor;

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
            // Banner upload section
            Container(
              width: double.infinity,
              height: 160,
              color: primaryColor.withOpacity(0.1),
              child: Column(
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Title your donation',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description field
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Describe your donation',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Images section
                  Text(
                    'Images',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Category dropdown
                  Row(
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Select Category',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: categories.length,
                                        itemBuilder: (context, index) {
                                          final category = categories[index];
                                          return ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Text(category),
                                            ),
                                            trailing:
                                                selectedCategory == category
                                                    ? Icon(Icons.check,
                                                        color: primaryColor)
                                                    : null,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      categoryProvider.notifier)
                                                  .state = category;
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
                        },
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
                                selectedCategory ?? 'Select Category',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: selectedCategory == null
                                          ? Colors.grey[400]
                                          : primaryColor,
                                    ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: primaryColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Item Condition dropdown
                  Row(
                    children: [
                      Text(
                        'Item Condition',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Select Item Condition',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: itemConditions.length,
                                        itemBuilder: (context, index) {
                                          final itemCondition =
                                              itemConditions[index];
                                          return ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Text(itemCondition),
                                            ),
                                            trailing: selectedItemCondition ==
                                                    itemCondition
                                                ? Icon(Icons.check,
                                                    color: primaryColor)
                                                : null,
                                            onTap: () {
                                              ref
                                                  .read(itemConditionProvider
                                                      .notifier)
                                                  .state = itemCondition;
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
                        },
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
                                selectedItemCondition ??
                                    'Select Item Condition',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: selectedItemCondition == null
                                          ? Colors.grey[400]
                                          : primaryColor,
                                    ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: primaryColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quantity selector
                  Row(
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
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
                            // Quantity value
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

                            // Plus button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => ref
                                    .read(quantityProvider.notifier)
                                    .update((state) => state + 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),

                            // Minus button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => ref
                                    .read(quantityProvider.notifier)
                                    .update((state) => state - 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                  Text(
                    'Pickup/Drop-off Option',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: options.map((option) {
                      final isSelected =
                          selectedPickupOption == option['label'];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(pickupOptionProvider.notifier).state =
                                option['label'] as String;
                          },
                          child: Container(
                            margin: option['label'] == 'Any'
                                ? null
                                : const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  option['icon'] as IconData,
                                  color:
                                      isSelected ? primaryColor : Colors.grey,
                                  size: 25,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  option['label'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: isSelected
                                            ? primaryColor
                                            : Colors.grey,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Recipient Selection Method
                  Text(
                    'Recipient Selection Method',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(recipientMethodProvider.notifier).state =
                                'Automatically';
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedRecipientMethod == 'Automatically'
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color:
                                    selectedRecipientMethod == 'Automatically'
                                        ? primaryColor
                                        : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Automatically',
                              style: TextStyle(
                                color:
                                    selectedRecipientMethod == 'Automatically'
                                        ? primaryColor
                                        : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(recipientMethodProvider.notifier).state =
                                'Manually';
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedRecipientMethod == 'Manually'
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: selectedRecipientMethod == 'Manually'
                                    ? primaryColor
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Manually',
                              style: TextStyle(
                                color: selectedRecipientMethod == 'Manually'
                                    ? primaryColor
                                    : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Contact info
                  Text(
                    'Contact Info',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add contact',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
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
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
