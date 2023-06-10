import 'package:flutter/material.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/images.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/views/register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key, }) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  // final String subtitle;
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  _storeBoardInfo() async{
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed).then((value) =>
        pushreplacement(context, const Register()));
  }

  Widget buildPage({
    // required Color color,
    required String imageUrl,
    required String description,
  })=> SafeArea(
    child: SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: () async{
                await _storeBoardInfo();
                // Navigator.of(context).pushNamed(signUp);
              },
                style: TextButton.styleFrom(backgroundColor: HexColor('#7B7FEC'),),
                child: const Text('Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                child: Image.asset(imageUrl,
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                height: 147,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.transparent,//Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.grey,
                          activeDotColor: HexColor('#7B7FEC'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Center(child: Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 5),
                      child: Text(description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    ),
                    isLastPage ?
                    GestureDetector(
                      onTap: () async{
                        await _storeBoardInfo();
                        // pushreplacement(context, Register());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: HexColor('#7B7FEC'),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: getProportionateScreenHeight(60),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                        :
                    GestureDetector(
                      onTap: () async{
                        controller.nextPage(duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                        // pushreplacement(context, Register());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: HexColor('#7B7FEC'),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: getProportionateScreenHeight(60),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index){
          setState(() {
            isLastPage = index == 2;
          });
        },
        children: [
          buildPage(
            imageUrl: onboard1,
            description: "Welcome to megas",
          ),
          buildPage(
            imageUrl: onboard2,
            description: "Meet and interact with people all\nover the world",
          ),
          buildPage(
              imageUrl: onboard3,
              description: 'Get started to get the best\nexperience'
          ),
        ],
      ),
    );
  }
}



