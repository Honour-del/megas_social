import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';

class UnderlineField extends StatelessWidget {
  const UnderlineField({Key? key, required this.label, required this.hint, this.suffixIcon, required this.keyboardType, this.controller, required this.obscure, this.validator,}) : super(key: key);

  final String? Function(String?)? validator;
  final String label;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(label,
                style: TextStyle(
                  color: primary_color,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 25,),

            TextFormField(
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                hintText: hint,
                suffixIcon: suffixIcon,
              ),
              controller: controller,
              validator: validator,
              obscureText: obscure,
              keyboardType: keyboardType,
            ),
          ],
        ),
      ),
    );
  }
}
