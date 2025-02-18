import 'package:flutter/material.dart';
import '../AppColors/appColors.dart';

class txtField_widget extends StatelessWidget {
  final String text;
  final TextInputType inputType;
  final TextEditingController textEditingController;
  final Icon icon;
  bool obscureText;
  final FormFieldValidator validator;


   txtField_widget(
      {Key? key,
      required this.text,
      required this.obscureText,
      required this.inputType,
      required this.textEditingController,
      required this.validator,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: height * 0.01,
        ),
        width: width * 0.9,
        child: TextFormField(
          obscureText: obscureText,
          textAlign: TextAlign.justify,
          validator: validator,
          style: TextStyle(fontFamily: 'Montserrat',fontSize: height * 0.019),
            controller: textEditingController,
          keyboardType: inputType,
          decoration: InputDecoration(
              suffixIcon: icon,
              hintStyle: TextStyle(fontFamily: 'Montserrat',fontSize:  height * 0.019),
              enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppColors.black) ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.black,),
                  borderRadius: BorderRadius.circular(15)),
              hintText: text),
        ),
      ),
    );
  }
}
