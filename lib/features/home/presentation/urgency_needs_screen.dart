import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopehive/core/models/request.dart';
import 'package:hopehive/widgets/request_card.dart';

class UrgencyNeedsScreen extends StatelessWidget {
  const UrgencyNeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Urgent Needs',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                final request = Request(
                  requestId: 'CmdAaAKXrkVTPtw849IU',
                  creator: 'OtAxiQwvQPSQKYYQROS9426DBGS2',
                  title: 'Title',
                  reason: 'Reason',
                  category: 'Educational & Office',
                  condition: 'Gently Used',
                  quantity: 2,
                  urgency: 'Urgent',
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
    );
  }
}
