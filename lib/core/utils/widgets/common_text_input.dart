
import 'package:flutter/material.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';

class CommonTextInput extends StatelessWidget {
  CommonTextInput(
      {super.key,
        this.label,
        this.obscureText = false,
        this.autoValidateMode,
        this.validator,
        this.suffixIcon,
        this.keyboardType,
        this.onChange,
        this.hintText,
        this.padding,
        this.borderInputNone = false,
        this.prefixIcon,
        this.customBorder,
        this.onTap,
        this.focusNode,
        this.filled,
        this.filledColor,
        this.hintStyle,
        this.readOnly,
        this.textInputAction,
        this.maxLength,
        this.enabled,
        this.controller,this.initialValue, this.focusBorder});

  final String? label;
  final String? hintText;
  final AutovalidateMode? autoValidateMode;
  final bool obscureText;
  final bool borderInputNone;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? filled;
  final Color? filledColor;
  final TextInputType? keyboardType;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  String? Function(String?)? onChange;
  final void Function()? onTap;
  final OutlineInputBorder? customBorder;
  final OutlineInputBorder? focusBorder;
  final FocusNode? focusNode;
  String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final bool? enabled;
  final int? maxLength;
  final TextStyle? hintStyle;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: autoValidateMode??AutovalidateMode.onUserInteraction,
      textInputAction: textInputAction,
      enabled: enabled,
      maxLength: maxLength,
      // style:
      //     TextStyle(fontSize: 16.sp, color: context.colorScheme.onBackground),
      cursorColor:context.primaryColor,
      textAlignVertical: TextAlignVertical.bottom,
      onTap: onTap,

      readOnly: readOnly ?? false,
      initialValue: initialValue,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: padding,
        filled: filled,
        fillColor: filledColor,
        labelStyle: TextStyle(fontSize: 16, color:context.primaryColor),
        label: label != null ? Text(label!) : null,
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(fontSize: 14, color: Colors.grey),
        counterText: '',
        border: customBorder,
        disabledBorder: customBorder,
        focusedBorder: focusBorder,
        enabledBorder:customBorder,
        // border:
      ),
      validator: validator,
      onChanged: onChange,
    );
  }
}
