import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/date_time_extention.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../view_model/sales_insert_controller.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(this.product, this.index, {super.key});
  final ProductModel product;
  final int index;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final SalesInsertController controller = Get.find();
  bool isFirstItem = false;

  @override
  void initState() {
    super.initState();
    if (widget.index == 0 && !controller.isProductListSeen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          controller.materialNumberKey,
          controller.materialDescriptionKey,
          controller.serialNoKey,
        ]);
      });
    }
    isFirstItem = widget.index == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.isProductSelected[widget.index].value;

      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ColoredBox(
          color: isSelected ? context.colorScheme.primary : Colors.transparent,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(right: 15),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide.none,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide.none,
            ),
            initiallyExpanded: isSelected,
            title: _buildTitle(context, isSelected),
            trailing: _buildTrailingIcon(isSelected),
            expandedAlignment: Alignment.topLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            children: _buildExpandedContent(isSelected),
            onExpansionChanged: (expanded) {
              // if (expanded) {
              //   controller.isProductSelected[widget.index].value = true;
              // } else {
              //   controller.isProductSelected[widget.index].value = false;
              // }
            },
          ),
        ),
      );
    });
  }

  Widget _buildTitle(BuildContext context, bool isSelected) {
    return ListTile(
      selected: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      leading: CircleAvatar(
        backgroundColor: isSelected ? null : context.primaryColor,
        child: Text(
          (widget.index + 1).toString(),
          style: TextStyle(color: isSelected ? null : Colors.white),
        ),
      ),
      // title: isFirstItem
      //     ? Showcase(
      //         key: controller.materialNumberKey,
      //         disposeOnTap: true,
      //         onBarrierClick: ShowCaseWidget.of(context).next,
      //         onTargetClick: ShowCaseWidget.of(context).next,
      //         onToolTipClick: ShowCaseWidget.of(context).next,
      //         description: 'Show Product Material No',
      //         title: 'Material No',
      //         child: _buildMaterialNumber(isSelected),
      //       )
      //     : _buildMaterialNumber(isSelected),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          isFirstItem
              ? Showcase(
            key: controller.serialNoKey,
            scrollLoadingWidget: const FlutterLogo(size: 50),
            description: 'Show Product Serial No',
            title: 'Product Serial No',
            disposeOnTap: true,
            onBarrierClick: controller.setProductListSeenTrue,
            onTargetClick: controller.setProductListSeenTrue,
            onToolTipClick: controller.setProductListSeenTrue,
            child: _buildSerialNumber(isSelected),
          )
              : _buildSerialNumber(isSelected),

          isFirstItem
              ? Showcase(
                  key: controller.materialDescriptionKey,
                  scrollLoadingWidget: const FlutterLogo(size: 50),
                  description: 'Show Product Material Description',
                  title: 'Material Description',
                  disposeOnTap: true,
                  onBarrierClick: ShowCaseWidget.of(context).next,
                  onTargetClick: ShowCaseWidget.of(context).next,
                  onToolTipClick: ShowCaseWidget.of(context).next,
                  child: _buildMaterialDescription(isSelected),
                )
              : _buildMaterialDescription(isSelected),

        ],
      ),
    );
  }

  // Widget _buildMaterialNumber(bool isSelected) {
  //   return RichText(
  //     text: TextSpan(
  //       children: [
  //         TextSpan(
  //           text: widget.product.materialNo,
  //           style: TextStyle(color: isSelected ? Colors.white : Colors.black),
  //         )
  //       ],
  //       text: "Material No : ",
  //       style: TextStyle(color: isSelected ? Colors.white : Colors.black),
  //     ),
  //   );
  // }

  Widget _buildMaterialDescription(bool isSelected) {
    return Text(
      widget.product.materialDescreption,
      style: TextStyle(color: isSelected ? Colors.white : null,fontSize: 15),
    );
  }

  Widget _buildSerialNumber(bool isSelected) {
    return Text(
      widget.product.serialNumber,
      style: TextStyle(color: isSelected ? Colors.white : null,fontSize: 15),
    );
  }

  Widget _buildTrailingIcon(bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.isProductSelected[widget.index].value = !isSelected;
      },
      child: FaIcon(
        isSelected
            ? FontAwesomeIcons.solidCheckCircle
            : FontAwesomeIcons.circle,
        color: isSelected ? Colors.white : context.primaryColor,
      ),
    );
  }

  List<Widget> _buildExpandedContent(bool isSelected) {
    return [
      _buildRichText('Sales No : ', widget.product.salesOrderNo, isSelected),
      const SizedBox(height: 5),
      _buildRichText(
          'Invoice Number : ', widget.product.invoiceNumber, isSelected),
      const SizedBox(height: 5),
      _buildRichText(
          'Invoice Date : ',
          DateTime.parse(widget.product.invoiceDate).format('dd-MMM-yyyy'),
          isSelected),
      const SizedBox(height:5),
      _buildRichText(
          'PO Number : ', widget.product.poNumber, isSelected),
    ];
  }

  Widget _buildRichText(String label, String value, bool isSelected) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 15.5,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15.5,
            ),
          ),
        ],
      ),
    );
  }
}
