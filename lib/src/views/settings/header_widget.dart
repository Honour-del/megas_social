import 'package:flutter/material.dart';
// import 'package:megas_chat/widgets/widgets/newWidget/customUrlText.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool secondHeader;
  final Color? color;
  const HeaderWidget(this.title,{Key? key, this.secondHeader = false, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: secondHeader ? EdgeInsets.only(left: 18, right: 18, bottom: 10, top: 10) : EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      color: color ?? Theme.of(context).appBarTheme.color,
      alignment: Alignment.centerLeft,
      child: Text(title ?? '',
        style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.headline6?.color,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
