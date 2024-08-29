import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/date_time_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_text_input.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';

import 'filter_item_selection_bottomsheet.dart';

class ProductFilterBottomSheet extends GetView<SalesInsertController> {
  const ProductFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Obx(
                  () {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Product Filters',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: context.primaryColor),
                            ),
                            IconButton(

                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close))
                          ],
                        ),
                        15.heightGap,
                        CommonTextInput(
                          customBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent)),
                          filled: true,
                          controller: controller.invoiceDateCtrl,
                          filledColor: context.primaryColor.withOpacity(.1),
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          onTap: () async {
                            DateTimeRange? range = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now());
                            if (range != null) {
                              controller.invoiceDateCtrl.text =
                              "${range.start.format('dd-MMM-yyyy')} To ${range.end.format('dd-MMM-yyyy')}";
                            }
                          },
                          suffixIcon: PopupMenuButton<String>(
                            onSelected: (String value) {
                              controller.invoiceDateCtrl.text = value;
                            },
                            color: Colors.white,
                            constraints: BoxConstraints.expand(height: 300,width: context.screenWidth*0.4),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Today',
                                child: Text('Today'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Yesterday',
                                child: Text('Yesterday'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Last 7 days',
                                child: Text('Last 7 days'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Last 30 days',
                                child: Text('Last 30 days'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Last 90 days',
                                child: Text('Last 90 days'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'This month',
                                child: Text('This month'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Last month',
                                child: Text('Last month'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                          // suffixIcon: IconButton(onPressed: (){
                          //   Get.dialog(DateRangeDialog(onChange: (val) {
                          //     controller.fromToDateCtrl.text=val;
                          //     Get.back();
                          //   },selectedRange: controller.fromToDateCtrl.text,));
                          // }, icon: const Icon(Icons.more_vert)),
                          label: "Select Invoice Date Range",
                          labelStyle: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 13,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SelectedItemWidget(
                          title: 'Select Sales No',
                          items: controller.selectedSalesNoList.value,
                          onItemRemove: (item) {
                            controller.selectedSalesNoList.value.firstWhere((element) => element == item).isSelected = false;
                            controller.selectedSalesNoList.refresh();
                          },
                          onEditPress: () {
                            Get.bottomSheet(
                              FilterItemSelectionBottomSheet(
                                title: 'Select Sales No',
                                items: controller.selectedSalesNoList.value,
                                onDone: (List<Item> items) {
                                  controller.selectedSalesNoList.value = items;
                                  controller.selectedSalesNoList.refresh();
                                },
                              ),
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SelectedItemWidget(
                          title: 'Select Product Group',
                          items: controller.productGroupList.value,
                          onItemRemove: (item) {
                            controller.productGroupList.value.firstWhere((element) => element == item).isSelected = false;
                            controller.productGroupList.refresh();
                          },
                          onEditPress: () {
                            Get.bottomSheet(
                              FilterItemSelectionBottomSheet(
                                title: 'Select Product Group',
                                items: controller.productGroupList.value,
                                onDone: (List<Item> items) {
                                  controller.productGroupList.value = items;
                                  controller.productGroupList.refresh();
                                },
                              ),
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SelectedItemWidget(
                          title: 'Select Invoice Number',
                          items: controller.invoiceNumberList.value,
                          onItemRemove: (item) {
                            controller.invoiceNumberList.firstWhere((element) => element == item).isSelected = false;
                            controller.invoiceNumberList.refresh();
                          },
                          onEditPress: () {
                            Get.bottomSheet(
                              FilterItemSelectionBottomSheet(
                                title: 'Select Invoice Number',
                                items: controller.invoiceNumberList.value,
                                onDone: (List<Item> items) {
                                  controller.invoiceNumberList.value = items;
                                  controller.invoiceNumberList.refresh();
                                },
                              ),
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SelectedItemWidget(
                          title: 'Select Serial Number',
                          items: controller.serialNumberList.value,
                          onItemRemove: (item) {
                            controller.serialNumberList.firstWhere((element) => element == item).isSelected = false;
                            controller.serialNumberList.refresh();
                          },
                          onEditPress: () {
                            Get.bottomSheet(
                              FilterItemSelectionBottomSheet(
                                title: 'Select Serial Number',
                                items: controller.serialNumberList.value,
                                onDone: (List<Item> items) {
                                  controller.serialNumberList.value = items;
                                  controller.serialNumberList.refresh();
                                },
                              ),
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },
                        ),

                      ],
                    );
                  },
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(Icons.search),
                  ))
            ],
          ),
        );
      },
    );
  }
}

class SelectedItemWidget extends StatelessWidget {
  const SelectedItemWidget(
      {super.key,
      required this.items,
      required this.onItemRemove,
      required this.onEditPress, required this.title});
  final List<Item> items;
  final String title;
  final Function(Item item) onItemRemove;
  final VoidCallback onEditPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: context.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              if(items.isEmpty) onEditPress();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                    title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                      onTap: () {
                        onEditPress();
                      },
                      child: const Icon(
                        FontAwesomeIcons.edit,
                        size: 19,
                      ))
                ],
              ),
            ),
          ),
          Wrap(
              spacing: 10,
              runSpacing: 2,
              children: items.where((element) => element.isSelected,).map(
                (e) {
                  return Chip(
                    label: Text(e.name),
                    onDeleted: () {
                      onItemRemove(e);
                    },
                  );
                },
              ).toList()),
        ],
      ),
    );
  }
}
