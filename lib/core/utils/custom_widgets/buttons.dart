import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/size_config.dart';

class FlatButton extends StatelessWidget {
  const FlatButton({Key? key, required this.onTap, required this.label, this.width, this.color, this.textColor}) : super(key: key);
  
  final VoidCallback onTap;
  final String label;
  final double? width;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? primary_color,
            border: Border.all(
              color: primary_color,
              width: 2,
            )
        ),
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        height: getProportionateScreenHeight(60),
        child: Align(
            alignment: Alignment.center,
            child: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w500, fontSize: getFontSize(19)),)),
      ),
    );
  }
}
