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
    return Obx(
          () {
        final isSelected = controller.isProductSelected[index].value;
        return ListTile(
          selected: isSelected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          selectedTileColor: isSelected ? context.colorScheme.primary: Colors.transparent,
          leading:CircleAvatar(backgroundColor:isSelected?null: context.primaryColor,child: Text((index+1).toString(),style: TextStyle(color: isSelected?null:Colors.white),),),
          title: Text(product.materialNo,style: TextStyle(color:isSelected?Colors.white:null ),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.materialDescreption,style: TextStyle(color:isSelected?Colors.white:null )),
              Text(product.serialNumber,style: TextStyle(color:isSelected?Colors.white:null )),
            ],
          ),
          tileColor:  context.colorScheme.secondary.withOpacity(.1),
          onTap: () {
            controller.isProductSelected[index].value = !controller.isProductSelected[index].value;
          },
        );
      },
    );
  }
}
