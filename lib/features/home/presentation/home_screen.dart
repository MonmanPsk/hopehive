import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final tabController = ref.watch(tabControllerProvider);
    final length = tabController.index == 0
        ? _donationLength * 110.0
        : _requestLength * 90.0;

    return SingleChildScrollView(
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
                        text: FirebaseAuth.instance.currentUser?.displayName
                                ?.split(' ')[0] ??
                            'User',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Icon(
                    Icons.bubble_chart,
                    size: 35,
                    color: Colors.white,
                  ),
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
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
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
                    return const DonationCard();
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
    );
  }
}
