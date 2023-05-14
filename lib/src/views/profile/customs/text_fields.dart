import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/size_config.dart';

class EditForm extends StatelessWidget {
  const EditForm({Key? key, required this.controller, required this.label, this.onChanged, this.validator}) : super(key: key);
  final TextEditingController controller;
  final String label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: getProportionateScreenWidth(15),right: getProportionateScreenWidth(20)),
      child: SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 19,
              ),
            ),

            const SizedBox(width: 18,),

            SizedBox(
              width: getProportionateScreenWidth(200),
              child: TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                ),
                controller: controller,
                onChanged: onChanged,
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
