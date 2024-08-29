import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';

class FilterItemSelectionBottomSheet extends StatefulWidget {
  const FilterItemSelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.onDone,
  });

  final String title;
  final List<Item> items;
  final Function(List<Item> items) onDone;

  @override
  _FilterItemSelectionBottomSheetState createState() =>
      _FilterItemSelectionBottomSheetState();
}

class _FilterItemSelectionBottomSheetState
    extends State<FilterItemSelectionBottomSheet> {
  late List<Item> _items;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _items = widget.items;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * 0.6,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              interactive: true,
              child: ListView.builder(
                controller: scrollController,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return CheckboxListTile(
                    value: item.isSelected,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onChanged: (bool? value) {
                      setState(() {
                        _items[index] =
                            Item(name: item.name, isSelected: value ?? false);
                      });
                    },
                    title: Text(item.name),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              widget.onDone(_items);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class Item {
   String name;
   bool isSelected;

  Item({
    required this.name,
    required this.isSelected,
  });

  Item copyWith({String? name, bool? isSelected}) {
    return Item(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
