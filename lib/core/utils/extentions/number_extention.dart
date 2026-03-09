import 'package:flutter/cupertino.dart';

extension NumberExtention on int{
  Widget get heightGap => SizedBox(height: toDouble());
  Widget get widthGap => SizedBox(width: toDouble());
}