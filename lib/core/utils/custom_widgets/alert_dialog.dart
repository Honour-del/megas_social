import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';

/// custom cupertino alert dialog box


class AlertBox extends StatelessWidget {
  const AlertBox({Key? key, this.firstGo, this.secondGo, this.thirdGo}) : super(key: key);
  final VoidCallback? firstGo;
  final VoidCallback? secondGo;
  final VoidCallback? thirdGo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          container1(),
          const SizedBox(height: 15,),
          container2(context),
        ],
      ),
    );
  }


  container1(){
    // String? first, String? second, String? third,
    return Container(
      height: getProportionateScreenHeight(184),
      width: getProportionateScreenWidth(326),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: firstGo,
              child: Text(
                "Delete Photo",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Divider(),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: secondGo,
              child: Text(
                "Take Photo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4,),
          Divider(),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: thirdGo,
              child: Text(
                "Choose Photo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  container2(BuildContext context){
    return Container(
      height: getProportionateScreenHeight(60),
      width: getProportionateScreenWidth(326),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
          color: Colors.white
      ),
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => popcontext(context),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
