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
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        if (index == events.length && isLoadingMore) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final event = events[index];
        final String? imageUrl = event['gambar_event'];

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
                    offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Text(
                                'Foto Tidak Tersedia',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['nama_event'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        event['kota_event'],
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'HTM: Rp ${event['htm_event']}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        (event['tanggal_event'] != null &&
                                event['waktu_event'] != null)
                            ? '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(event['tanggal_event']))} ${event['waktu_event']}'
                            : '-',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
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
