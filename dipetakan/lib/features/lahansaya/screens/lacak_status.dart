import 'package:dipetakan/features/petalahan/controllers/infolahan_controller.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Import for GetX controller
import 'package:timeline_tile/timeline_tile.dart';

class LacakStatusScreen extends StatefulWidget {
  final LahanModel lahan;

  const LacakStatusScreen({super.key, required this.lahan});

  @override
  State<LacakStatusScreen> createState() => _LacakStatusScreenState();
}

class _LacakStatusScreenState extends State<LacakStatusScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting(
        'id_ID'); // Initialize date formatting for the locale
  }

  String formatTimestamp(Timestamp timestamp) {
    final DateFormat formatter =
        DateFormat("EEEE, d MMMM yyyy hh:mm a", "id_ID");
    DateTime dateTime = timestamp.toDate();
    return formatter.format(dateTime);
  }

  String getStatusText(int statusverifikasi) {
    switch (statusverifikasi) {
      case 0:
        return 'Belum tervalidasi';
      case 1:
        return 'Dalam progress';
      case 2:
        return 'Sudah tervalidasi';
      default:
        return 'Tidak ada status';
    }
  }

  Color getStatusColor(int statusverifikasi, bool isFirst) {
    if (!isFirst) {
      return Colors.grey;
    }
    switch (statusverifikasi) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InfoLahanController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Lacak Status',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontStyle: FontStyle.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<LahanModel>>(
        stream: controller.lahanStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load lahan data'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final lahanList = snapshot.data!;
          final lahan = lahanList.firstWhere(
            (element) => element.id == widget.lahan.id,
            orElse: () => widget.lahan,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(DSizes.defaultSpace),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Kontak Admin',
                    //   style: Theme.of(context).textTheme.headlineSmall,
                    // ),
                    // const SizedBox(height: DSizes.md),
                    // Text(
                    //   'Nama Admin',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(height: DSizes.md),
                    // Text(
                    //   'No Telepon Admin',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(height: DSizes.md),
                    // Text(
                    //   'Email Admin',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(height: DSizes.md),
                    // const Divider(),
                    // const SizedBox(height: DSizes.md),
                    Text(
                      'Status Ajuan',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: DSizes.md),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lahan.verifikasi.length,
                      itemBuilder: (context, index) {
                        // final reversedIndex =
                        // lahan.verifikasi.length - 1 - index;
                        final verifikasi = lahan.verifikasi[index];
                        final isFirst = index == 0;
                        final isLast = index == lahan.verifikasi.length - 1;
                        final color = getStatusColor(
                            verifikasi.statusverifikasi, isFirst);

                        return TimelineTile(
                          alignment: TimelineAlign.start,
                          isFirst: isFirst,
                          isLast: isLast,
                          indicatorStyle:
                              IndicatorStyle(width: 12, color: color),
                          beforeLineStyle: LineStyle(color: color),
                          endChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                getStatusText(verifikasi.statusverifikasi),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatTimestamp(verifikasi.verifiedAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                  Text(
                                    verifikasi.comentar.isNotEmpty
                                        ? verifikasi.comentar
                                        : 'Tidak ada komentar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
