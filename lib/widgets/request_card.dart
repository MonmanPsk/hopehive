import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hopehive/core/models/request.dart';
import 'package:hopehive/core/routes.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.request});

  final Request request;

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      // Fetch placemarks from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // Construct a readable address
        return '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country} ${place.postalCode}';
      }
    } catch (e) {
      // Handle errors (e.g., no internet or invalid coordinates)
      return 'Unable to fetch address';
    }
    return 'No address found';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> urgencyColor = {
      'Flexible': Theme.of(context).primaryColor,
      'Soon': Colors.amber,
      'Urgent': const Color(0xFFF94449),
    };

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.request, arguments: request),
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
                        child: FutureBuilder(
                          future: _getAddressFromCoordinates(
                            request.location.latitude,
                            request.location.longitude,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              );
                            }
                          },
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
