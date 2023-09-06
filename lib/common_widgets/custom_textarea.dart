import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';

class CustomTextArea extends StatefulWidget {
  const CustomTextArea({
    Key? key,
    required this.labelText,
    this.inputFormatters,
    this.initialValue,
    this.isReadOnly = false,
    this.validator,
    this.controller,
    this.textInputType,
    this.onSaved,
    this.formFieldKey,
    this.onFieldSubmitted,
    this.minlines,
    this.maxlines,
  }) : super(key: key);

  final String labelText;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool isReadOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final GlobalKey<FormFieldState>? formFieldKey;
  final Function(String)? onFieldSubmitted;
  final int? minlines;
  final int? maxlines;

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  // * Obscure text while typing

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: Get.textTheme.bodyMedium,
        ),
        gapH4,
        TextFormField(
          key: widget.formFieldKey,
          minLines: widget.minlines,
          maxLines: widget.maxlines,
          style: Get.textTheme.displaySmall,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          readOnly: widget.isReadOnly,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.neutral300,
              ),
              borderRadius: BorderRadius.circular(
                Sizes.p6,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.neutral300,
              ),
              borderRadius: BorderRadius.circular(
                Sizes.p6,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.neutral300,
              ),
              borderRadius: BorderRadius.circular(
                Sizes.p6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
