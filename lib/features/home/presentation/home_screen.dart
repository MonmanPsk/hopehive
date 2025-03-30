import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/models/donation.dart';
import 'package:hopehive/core/providers/user_provider.dart';
import 'package:hopehive/core/routes.dart';
import 'package:hopehive/features/home/domain/home_screen_provider.dart';
import 'package:hopehive/widgets/donation_card.dart';
import 'package:hopehive/widgets/request_card.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final List<List<dynamic>> _quickAccess = [
    [
      ['Create', 'Donation'],
      Icons.grid_view_rounded,
      AppRoutes.createDonation
    ],
    [
      ['Create', 'Request'],
      Icons.grid_view_rounded,
      AppRoutes.createRequest
    ],
    [
      ['', 'Pickup &\nDrop-off'],
      Icons.grid_view_rounded,
      AppRoutes.pickupDropoff
    ],
    [
      ['', 'Urgent Needs'],
      Icons.grid_view_rounded,
      AppRoutes.urgencyNeeds
    ],
  ];

  final int _donationLength = 8;
  final int _requestLength = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue =
        ref.watch(userProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final user = userAsyncValue.value;
    final tabController = ref.watch(tabControllerProvider);
    final length = tabController.index == 0
        ? _donationLength * 110.0
        : _requestLength * 90.0;

    return userAsyncValue.when(
      data: (data) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Welcome,\n',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(
                          text: user?.firstname ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: user?.profileImage != null
                        ? NetworkImage(user?.profileImage ?? '')
                        : null,
                    child: user?.profileImage == null
                        ? const Icon(
                            Icons.bubble_chart_rounded,
                            size: 35,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Quick Access',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
              ),
              itemCount: _quickAccess.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      _quickAccess[index][2],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _quickAccess[index][1],
                          size: 20,
                        ),
                        const SizedBox(width: 15),
                        RichText(
                          text: TextSpan(
                            text: _quickAccess[index][0][0] == ''
                                ? null
                                : '${_quickAccess[index][0][0]}\n',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                            children: [
                              TextSpan(
                                text: _quickAccess[index][0][1],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Explore',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            TabBar(
              controller: tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Donation'),
                Tab(text: 'Request'),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: length,
              child: TabBarView(
                clipBehavior: Clip.none,
                controller: tabController,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _donationLength,
                    itemBuilder: (context, index) {
                      Donation donation = Donation(
                        donationId: 'jcUlfmAc3QWjYE2BWCiX',
                        creator: 'OtAxiQwvQPSQKYYQROS9426DBGS2',
                        banner:
                            'https://firebasestorage.googleapis.com/v0/b/hopehive-8e99e.firebasestorage.app/o/donation_images%2F1743359244958?alt=media&token=87514505-7404-45ca-94e4-e4f3767255d5',
                        title: 'Title',
                        description: 'Description',
                        images: [
                          'https://firebasestorage.googleapis.com/v0/b/hopehive-8e99e.firebasestorage.app/o/donation_images%2F1743359244195?alt=media&token=64f9aa00-a0b9-4913-8387-c1e7e60c72b0',
                        ],
                        category: 'Essential Needs',
                        condition: 'New',
                        quantity: 3,
                        location: const GeoPoint(13.164856, 13.164856),
                        option: 'Any',
                        contact: [
                          {'Chat': null}
                        ],
                        createdAt: Timestamp.now(),
                      );
                      return DonationCard(
                        donation: donation,
                      );
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _requestLength,
                    itemBuilder: (context, index) {
                      return const RequestCard();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stack) {
        return Center(
          child: Text(
            'Error: $error',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        );
      },
    );
  }
}
