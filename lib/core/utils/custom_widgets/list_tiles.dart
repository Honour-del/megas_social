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
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        leading: leading,
        trailing: trailing,
        subtitle: Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        onTap: onTap,
      ),
    );
  }
}
