import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_button.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_text_input.dart';

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
  late List<Item> items;
  late List<Item> _filteredItems;
  late ScrollController scrollController;
  TextEditingController searchController = TextEditingController();
  RxBool isSearching = false.obs;
  RxBool isCheckedAll = false.obs;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    items = widget.items;
    _filteredItems = List.of(items);
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        focusNode.requestFocus();
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onSearchQuery(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      // Retain the selection state when resetting to the original list
      _filteredItems = items.map((item) {
        final filteredItem = _filteredItems.firstWhere(
          (filtered) => filtered.name == item.name,
          orElse: () => Item(name: item.name, isSelected: item.isSelected),
        );
        return Item(name: item.name, isSelected: filteredItem.isSelected);
      }).toList();
    } else {
      isSearching.value = true;
      _filteredItems = items
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .map((item) {
        final filteredItem = _filteredItems.firstWhere(
          (filtered) => filtered.name == item.name,
          orElse: () => Item(name: item.name, isSelected: item.isSelected),
        );
        return Item(name: item.name, isSelected: filteredItem.isSelected);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * 0.6,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonTextInput(
              controller: searchController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              label: 'Search ${widget.title.replaceAll("Select", "").trim()}',
              focusNode: focusNode,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isSearching.value
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            searchController.clear();
                            onSearchQuery('');
                          },
                        )
                      : SizedBox(),
                  IconButton(
                      onPressed: () {
                        if (_filteredItems
                            .any((element) => !element.isSelected)) {
                          isCheckedAll.value = true;
                          _filteredItems = _filteredItems
                              .map((e) => Item(name: e.name, isSelected: true))
                              .toList();
                        } else {
                          isCheckedAll.value = false;
                          _filteredItems = _filteredItems
                              .map((e) => Item(name: e.name, isSelected: false))
                              .toList();
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.checklist_rounded,
                        color: isCheckedAll.value
                            ? context.colorScheme.primary
                            : null,
                      ))
                ],
              ),
              onChange: (val) {
                onSearchQuery(val ?? '');
              },
            ),
          ),
          // const Divider(),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Text('No Record Found'),
                  )
                : Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return CheckboxListTile(
                          value: item.isSelected,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onChanged: (bool? value) {
                            setState(() {
                              _filteredItems[index] = Item(
                                  name: item.name, isSelected: value ?? false);
                              // Update the original list as well
                              final originalIndex = items.indexWhere(
                                  (element) => element.name == item.name);
                              if (originalIndex != -1) {
                                if (!(value ?? false))
                                  isCheckedAll.value = false;

                                items[originalIndex] = Item(
                                    name: item.name,
                                    isSelected: value ?? false);
                              }
                            });
                          },
                          title: Text(item.name),
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonButton(
                borderRadius: 10,
                backgroundColor: context.colorScheme.primary,
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Get.back();
                  widget.onDone(_filteredItems);
                }),
          ),
          if (false)
            ElevatedButton(
              onPressed: () {
                Get.back();
                widget.onDone(_filteredItems);
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
  String? productId;
  bool isSelected;

  Item({
    required this.name,
    this.productId,
    required this.isSelected,
  });

  Item copyWith({String? name, String? productId, bool? isSelected}) {
    return Item(
      name: name ?? this.name,
      productId: productId ?? this.productId,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

