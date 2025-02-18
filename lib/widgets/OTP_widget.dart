import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../AppColors/appColors.dart';

class OtpController extends StatelessWidget {
  final TextEditingController controller;
  final bool last;
  final bool first;
  const OtpController({Key? key,required this.controller, required this.last, required this.first}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.075,
      width: width * 0.18,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: AppColors.black, width: 1.5)),
      child: Center(
        child: TextFormField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          controller: controller,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          inputFormatters:[LengthLimitingTextInputFormatter(1),],
          maxLength: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterStyle:  TextStyle(height: double.minPositive,),
            counter: SizedBox.shrink(),
            hintText: '',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
