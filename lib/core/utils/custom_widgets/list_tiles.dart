import 'package:flutter/material.dart';

class Tiles extends StatelessWidget {
  const Tiles({Key? key, required this.title, this.leading, required this.onTap, this.trailing, this.subtitle}) : super(key: key);
  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),),
        leading: leading,
        trailing: trailing,
        subtitle: Text(subtitle!, style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w100),),
        onTap: onTap,
      ),
    );
  }
}
