import 'package:contacts/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final String? hintText;
  final bool? obscureText;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final Function(String?)? onSaved;
  final Function(String?)? onFieldSubmitted;
  final TextInputType? textInputType;
  final int? maxLength;
  final Widget? counter;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Color? fillColor;
  const CustomTextFormField(
      {super.key,
        this.inputFormatters,
        this.controller,
        this.hintText,
        this.validator,
        this.onChanged,
        this.suffix,
        this.onSaved,
        this.onFieldSubmitted,
        this.obscureText,
        this.readOnly,
        this.height,
        this.width,
        this.textInputType,
        this.maxLength,
        this.counter,
        this.suffixIcon,
        this.prefixIcon,
      this.fillColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obscureText??false,
        validator: validator,
        scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        inputFormatters: inputFormatters,
        controller: controller,
        onSaved: onSaved,
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
        readOnly: readOnly??false,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: textInputType ?? TextInputType.text,
        maxLength: maxLength,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.white),
          fillColor: fillColor??AppConstants.page_color,
          filled: true,
          hintText: hintText??"",
          counter: counter,
          suffix: suffix,
          suffixIcon: suffixIcon ?? null,
          prefixIcon: prefixIcon ?? null,
          hintStyle: const TextStyle(fontSize: 16.0,),
          // isDense: true,
          contentPadding:EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }
}