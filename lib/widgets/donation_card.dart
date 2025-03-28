import 'package:flutter/material.dart';
import 'package:hopehive/core/routes.dart';

class DonationCard extends StatelessWidget {
  const DonationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.donation),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Location',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      'Category: ',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: Text(
                        'Any',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text(
                      'Condition: ',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: Text(
                        'Any',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
