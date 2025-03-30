import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/models/donation.dart';
import 'package:hopehive/core/models/request.dart';
import 'package:hopehive/core/providers/user_provider.dart';
import 'package:hopehive/core/routes.dart';
import 'package:hopehive/features/profile/domain/profile_provider.dart';
import 'package:hopehive/widgets/donation_card.dart';
import 'package:hopehive/widgets/request_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  final int _donationLength = 5;
  final int _requestLength = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(tabControllerProvider);
    final userAsyncValue =
        ref.watch(userProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final user = userAsyncValue.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: user?.profileImage != null
                          ? NetworkImage(user?.profileImage ?? '')
                          : null,
                      child: user?.profileImage == null
                          ? const Icon(
                              Icons.bubble_chart_rounded,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user?.firstname ?? ''} ${user?.lastname ?? ''}',
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.editProfile,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: const Icon(
                              Icons.handshake_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Donated',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                '11',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: const Icon(
                              Icons.back_hand_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Received',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                '3',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: tabController,
              indicatorPadding: const EdgeInsets.all(5),
              indicatorWeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).primaryColor,
              dividerHeight: 0,
              tabs: const [
                Tab(text: 'My Donation'),
                Tab(text: 'My Request'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: tabController.index == 0
                ? (_donationLength * 110.0 + 80.0)
                : (_requestLength * 90.0 + 80.0),
            child: TabBarView(
              clipBehavior: Clip.none,
              controller: tabController,
              children: [
                // Donations tab
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.createDonation),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 10),
                              Text(
                                'Create a new donation',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _donationLength,
                        itemBuilder: (context, index) {
                          final donation = Donation(
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
                    ],
                  ),
                ),
                // Requests tab
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.createRequest),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 10),
                              Text(
                                'Create a new request',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _requestLength,
                        itemBuilder: (context, index) {
                          final request = Request(
                            requestId: 'CmdAaAKXrkVTPtw849IU',
                            creator: 'OtAxiQwvQPSQKYYQROS9426DBGS2',
                            title: 'Title',
                            reason: 'Reason',
                            category: 'Educational & Office',
                            condition: 'Gently Used',
                            quantity: 2,
                            urgency: 'Soon',
                            location: const GeoPoint(13.164856, 13.164856),
                            option: 'Pickup',
                            contact: [
                              {'Chat': null}
                            ],
                            createdAt: Timestamp.now(),
                          );
                          return RequestCard(request: request);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
