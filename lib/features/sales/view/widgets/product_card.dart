import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';
class ProductCard extends GetView<SalesInsertController> {
  const ProductCard(this.product, this.index, {super.key});
  final ProductModel product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
          () {
        final isSelected = controller.isProductSelected[index].value;
        return ListTile(
          selected: isSelected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          selectedTileColor: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
          leading: CachedNetworkImage(
            imageUrl: "https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg",
            height: 50, width: 50,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          title: Text(product.name),
          subtitle: Text(product.description),
          trailing: Text(product.mrp, style: const TextStyle(fontWeight: FontWeight.bold)),
          tileColor: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
          onTap: () {
            controller.isProductSelected[index].value = !controller.isProductSelected[index].value;
          },
        );
      },
    );
  }
}
