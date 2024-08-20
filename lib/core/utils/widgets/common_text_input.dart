import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        this.labelStyle,
        this.filled,
        this.filledColor,
        this.hintStyle,
        this.readOnly,
        this.inputFormatters,
        this.textInputAction,
        this.style,
        this.maxLength,
        this.enabled,
        this.lableWidget,
        this.autoValidateNull=false,
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
  final void Function(String?)? onChange;
  final void Function()? onTap;
  final InputBorder? customBorder;
  final InputBorder? focusBorder;
  final FocusNode? focusNode;
  String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final bool? enabled;
  final int? maxLength;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final String? initialValue;
  final bool autoValidateNull;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? lableWidget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      obscureText: obscureText,

      autovalidateMode:autoValidateNull?null:( autoValidateMode??AutovalidateMode.onUserInteraction),
      textInputAction: textInputAction??TextInputAction.next,
      enabled: enabled,
      inputFormatters:inputFormatters ,
      maxLength: maxLength,
      // style:
      //     GoogleFonts.montserrat(fontSize: 16.sp, color: context.colorScheme.onBackground),
      cursorColor:context.primaryColor,
      textAlignVertical: TextAlignVertical.bottom,
      onTap: onTap,
      style: style,
      readOnly: readOnly ?? false,
      initialValue: initialValue,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: padding,
        filled: filled,
        fillColor: filledColor,
        labelStyle: TextStyle(fontSize: 16, color:context.primaryColor),
        label: lableWidget?? (label != null ? Text(label!,style: labelStyle,) : null),
        hintText: hintText,
        hintStyle: hintStyle ??  TextStyle(fontSize: 14, color: Colors.grey),
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
