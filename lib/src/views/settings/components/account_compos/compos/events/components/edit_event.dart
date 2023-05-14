//

import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:megas/core/entities/entities.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
// import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/src/services/events_repository.dart';

class EditEvent extends ConsumerStatefulWidget {
  const EditEvent({
    Key? key,
    required this.event
  }) : super(key: key);
  
  final Event event;
  @override
  ConsumerState<EditEvent> createState() => _AddEventState();
}
final form = GlobalKey<FormState>();
class _AddEventState extends ConsumerState<EditEvent> {

  @override
  void initState(){
    super.initState();
    title.text = "${widget.event.title}";
    note.text = "${widget.event.note}";
  }

  @override
  void dispose(){
    title.dispose();
    note.dispose();
    super.dispose();
  }
  File? _image;
  ImagePicker _imagePicker = ImagePicker();
  DateTime? selectedDate;
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  Future _selectDayAndTime(BuildContext context) async {
    DateTime? _selectedDay = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) => child!);

    TimeOfDay? _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_selectedDay != null && _selectedTime != null) {
      setState(() {
        selectedDate = DateTime(
          _selectedDay.year,
          _selectedDay.month,
          _selectedDay.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  String titles = '';
  String descriptions = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,////80
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: primary_color),
        // leading: Text('yes'),
        shadowColor: Colors.transparent,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              // top: 30,
                left: 12,
                right: 12
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Color(0xffEE197F))),
                // SizedBox(width: getProportionateScreenWidth(58),),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Edit event",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        // fontFamily: "MISTRAL",
                        // fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                  ),
                ),

                SizedBox(width: getProportionateScreenWidth(58),),

                // SizedBox(width: getProportionateScreenWidth(12),),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add Event",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              TitleText(
                text: "Title of Event",
              ),
              SizedBox(
                height: 5.0.h,
              ),
              TextFormField(
                controller: title,
                // initialValue: "${widget.event.title}",
                decoration: InputDecoration(
                  hintText: "${widget.event.title}",
                  // hintText: '',
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black38),
                  filled: true,
                  isDense: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  enabledBorder: outlineBorder,
                  focusedBorder: outlineBorder,
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              TitleText(
                text: "Date of Event",
              ),
              SizedBox(
                height: 5.0.h,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _selectDayAndTime(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "${widget.event.date}"
                              : DateFormat("dd-MM-yyyy").format(selectedDate!),
                          style: TextStyle(fontSize: 14.sp, color: Colors.black38),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              TitleText(text: "Background Image"),
              SizedBox(
                height: 5.0.h,
              ),
              InkWell(
                onTap: () {
                  _getImage(ImageSource.gallery);
                },
                child: Container(
                  height: 150.0.h,
                  decoration: DottedDecoration(
                    shape: Shape.box,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: _image == null ? Center(  //Image.file(widget.event.imagePath as File),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: Colors.grey[400],
                            size: 30,
                          ),
                          Text(
                            "Tap to select Image",
                            style:
                            TextStyle(fontSize: 14.sp, color: Colors.black38),
                          )
                        ],
                      ),
                    ) : Image.file(_image!),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TitleText(text: "Description"),
              SizedBox(
                height: 5.h,
              ),
              Container(
                height: 150.0.h,
                padding: EdgeInsets.all(5.0.w),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  // border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  maxLines: null,
                  controller: note,
                  // initialValue: "${widget.event.note}",
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black38),
                      hintText: "${widget.event.note}",
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () async{
                  if(form.currentState!.validate()){
                    form.currentState!.save();
                    final events = await ref.read(eventRepositoryProvider).
                    updateCard(index: widget.event.id,event: Event(title: title.text, date: selectedDate!, note: note.text, imagePath: _image!.path));

                    print("Printed event: ${events.toString()}");
                    popcontext(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        //stops: [0.7, 1.0],
                        colors: <Color>[
                          Color(0xffFEA831),
                          Color(0xffEE197F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Text(
                      "Add Event",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if(pickedFile == null) return;
      final imageTemp = File(pickedFile.path);
      setState(() {
        _image = imageTemp;
      });
      // popcontext(context);

    } on PlatformException catch (e) {
      throw('Failed to pick image: $e');
    }
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
