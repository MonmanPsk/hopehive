import 'package:flutter/material.dart';
import 'package:hopehive/core/models/request.dart';
import 'package:hopehive/core/routes.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.request});

  final Request request;

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> urgencyColor = {
      'Flexible': Theme.of(context).primaryColor,
      'Soon': Colors.amber,
      'Urgent': const Color(0xFFF94449),
    };

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.request),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          '${request.location.latitude}, ${request.location.longitude}',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Category: ',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          child: Text(
                            request.category,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: urgencyColor[request.urgency]?.withOpacity(0.1),
                  ),
                  child: Text(
                    request.urgency,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: urgencyColor[request.urgency],
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
