import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/sales_card.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_view_controller.dart';

import '../../../core/utils/constants/app_assets.dart';

class SalesListView extends GetView<SalesViewController> {
  const SalesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text('Sales Data')),
            15.widthGap,
            InkWell(
              onTap: () async {
                // Show Date Filter BottomSheet/Dialog
                final pickedDates = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );

                if (pickedDates != null) {
                  controller.filterFromDate.value = pickedDates.start;
                  controller.filterToDate.value = pickedDates.end;
                  controller.getSalesData(); // or controller.filterSalesData();
                }
              },
              child: const Icon(Icons.filter_alt, size: 28),
            ),
            15.widthGap,
            SvgPicture.asset(
              AppAssets.ksbLogo,
              height: 25,
            ),
          ],
        ),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.salesList.isEmpty) {
            return const Center(child: Text('No Record Found'));
          }

          int totalSerials = controller.salesList.fold<int>(
            0,
                (int prev, item) {
              int count = 0;
              if (item.products != null) {
                for (var product in item.products) {
                  count += product.serialNumber.length ?? 0;
                  print('Serial number ${count}');
                }
              }
              return prev + count;
            },
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.filterFromDate.value != null &&
                        controller.filterToDate.value != null)
                      Center(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Filtered From: ${DateFormat('dd-MM-yyyy').format(controller.filterFromDate.value!)}"
                                  " To: ${DateFormat('dd-MM-yyyy').format(controller.filterToDate.value!)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    5.heightGap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Total Entries: ",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${controller.salesList.length}",
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Total Serial Numbers: ",
                                  style: const TextStyle(fontSize: 16),
                                ),

                                Text(
                                  "$totalSerials",
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.getSalesData();
                  },
                  child: AnimationLimiter(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => 15.heightGap,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      itemCount: controller.filteredSalesList.length,
                      itemBuilder: (context, index) {
                        final data = controller.salesList[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: SalesCard(data: data)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

  }
}
