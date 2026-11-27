import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ksb_secondary_sales/features/sales/view/sales_insert.dart';

import '../../../sales/view/product_selection.dart';

class AddFab extends StatelessWidget {
  const AddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      // tappable: false,
      closedElevation: 5,
      closedShape: const CircleBorder(),
      // openShape: const CircleBorder(),
      openBuilder: (context, action) {
        return ProductSelection();
      },
      closedBuilder: (context, action) {
        return FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            action.call();
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}
