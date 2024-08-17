import 'package:flutter/material.dart';

class TapToRemoveKeyboardWidget extends StatelessWidget {
  const TapToRemoveKeyboardWidget({super.key, required this.child});
final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(child: GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
        child: child),);
  }
}
