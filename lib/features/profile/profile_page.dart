import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/providers/donation_request_provider.dart';
import 'package:hopehive/core/providers/user_provider.dart';
import 'package:hopehive/core/routes.dart';
import 'package:hopehive/features/profile/domain/profile_provider.dart';
import 'package:hopehive/widgets/donation_card.dart';
import 'package:hopehive/widgets/request_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(tabControllerProvider);
    final userAsyncValue =
        ref.watch(userProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final user = userAsyncValue.value;

    // Watch donation and request streams
    final donationsAsyncValue = ref.watch(donationsStreamProvider);
    final requestsAsyncValue = ref.watch(requestsStreamProvider);

    // Get dynamic heights based on available data
    final donationsLength = donationsAsyncValue.when(
      data: (donations) => donations.length * 110.0 + 80.0,
      loading: () => 8 * 110.0, // Default height while loading
      error: (_, __) => 110.0, // Minimal height on error
    );

    final requestsLength = requestsAsyncValue.when(
      data: (requests) => requests.length * 90.0 + 80.0,
      loading: () => 6 * 90.0, // Default height while loading
      error: (_, __) => 90.0, // Minimal height on error
    );

    final length = tabController.index == 0 ? donationsLength : requestsLength;

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
            height: tabController.index == 0 ? donationsLength : requestsLength,
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
                      donationsAsyncValue.when(
                        data: (donations) {
                          if (donations.isEmpty) {
                            return Center(
                              child: Text(
                                'No donations available',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: donations.length,
                            itemBuilder: (context, index) {
                              return DonationCard(
                                donation: donations[index],
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (error, stack) {
                          return Center(
                            child: Text(
                              'Error loading donations: ${error.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
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
                      requestsAsyncValue.when(
                        data: (requests) {
                          if (requests.isEmpty) {
                            return Center(
                              child: Text(
                                'No requests available',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: requests.length,
                            itemBuilder: (context, index) {
                              return RequestCard(
                                request: requests[index],
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (error, stack) {
                          return Center(
                            child: Text(
                              'Error loading requests: ${error.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          );
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
