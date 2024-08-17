import 'package:flutter/material.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.height,
      this.width,
      this.padding = EdgeInsets.zero,
      this.isLoading = false,
      this.backgroundColor});
  final Widget child;
  final void Function()? onPressed;
  final double? height;
  final double? width;
  final EdgeInsets padding;
  final bool isLoading;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.screenWidth,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
          onPressed: isLoading ? null : onPressed,
          child: Padding(
            padding: padding,
            child: isLoading
                ?  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )),
                      Text('   Please Wait...')
                    ],
                  )
                : child,
          )),
    );
  }
}
