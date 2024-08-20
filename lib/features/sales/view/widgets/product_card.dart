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
          selectedTileColor: isSelected ? context.colorScheme.primary: Colors.transparent,

          leading: CachedNetworkImage(
            // color: Colors.black,
            imageUrl: product.imgUrl,
            height: 45, width: 45,
            imageBuilder: (context, imageProvider) => Container(
              clipBehavior: Clip.hardEdge,
                height: 20,width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Image(image: imageProvider,fit: BoxFit.cover,)),
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          title: Text(product.name,style: TextStyle(color:isSelected?Colors.white:null ),),
          subtitle: Text(product.description,style: TextStyle(color:isSelected?Colors.white:null )),
          trailing: Text(product.mrp, style:  TextStyle(fontWeight: FontWeight.bold,color:isSelected? Colors.white:null)),
          tileColor:  context.colorScheme.secondary.withOpacity(.1),
          onTap: () {
            controller.isProductSelected[index].value = !controller.isProductSelected[index].value;
          },
        );
      },
    );
  }
}
