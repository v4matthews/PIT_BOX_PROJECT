import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/race_page/detail_page.dart';
import 'package:pit_box/components/asset_warna.dart';

class EventListView extends StatelessWidget {
  final List events;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const EventListView({
    super.key,
    required this.events,
    required this.isLoadingMore,
    required this.scrollController,
    required this.isSmallScreen,
    required this.isMediumScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: events.length + (isLoadingMore ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen
            ? 2
            : isMediumScreen
                ? 3
                : 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio:
            0.55, // Ubah dari 0.65 ke 0.55 untuk membuat lebih tinggi
      ),
      itemBuilder: (context, index) {
        if (index == events.length && isLoadingMore) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final event = events[index];
        final String? imageUrl = event['image_event'];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(event: event),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section with fixed aspect ratio
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 3 / 4, // More standard aspect ratio for cards
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey[400]),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Text(
                                'No Image',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),

                // Content section with flexible space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['nama_event'] ?? 'No Event Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event['kota_event'] ?? 'No Location',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HTM: Rp ${event['htm_event'] ?? '0'}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (event['tanggal_event'] != null &&
                                      event['waktu_event'] != null)
                                  ? '${DateFormat('dd MMM yyyy').format(DateTime.parse(event['tanggal_event']))} | ${event['waktu_event']}'
                                  : 'No Date/Time',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
