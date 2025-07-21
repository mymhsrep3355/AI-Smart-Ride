// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:smart_ride/src/modules/utlis/app_colors.dart';
// import 'package:smart_ride/src/modules/utlis/app_fonts.dart';

// class Textfield extends StatefulWidget {
//   final String hintKey;
//   final IconData? icon;
//   final TextEditingController? controller;
//   final bool isObscure;
//   final bool isPhone;
//   final bool isPassword;
//   final TextInputType inputType;
//   final List<TextInputFormatter>? inputFormatters;
//   final int? maxLength;
//   final String? Function(String?)? validator;

//   const Textfield({
//     super.key,
//     required this.hintKey,
//     this.icon,
//     this.controller,
//     this.isObscure = false,
//     this.inputType = TextInputType.text,
//     this.inputFormatters,
//     this.maxLength,
//     this.validator,
//     this.isPhone = false,
//     this.isPassword = false,
//   });

//   @override
//   State<Textfield> createState() => _TextfieldState();
// }

// class _TextfieldState extends State<Textfield> {
//   bool _obscure = true;

//   @override
//   void initState() {
//     super.initState();
//     _obscure = widget.isPassword;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       obscureText: widget.isPassword ? _obscure : false,
//       keyboardType: widget.inputType,
//       inputFormatters: widget.isPhone
//           ? [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(10),
//             ]
//           : widget.inputFormatters,
//       maxLength: widget.maxLength,
//       validator: widget.validator,
//       style: StyleRefer.poppinsRegular.copyWith(
//         color: AppColorss.text,
//         fontSize: 14,
//       ),
//       decoration: InputDecoration(
//         prefixText: widget.isPhone ? '+92' : null,
//         prefixStyle: StyleRefer.poppinsRegular.copyWith(
//           color: AppColorss.text,
//           fontSize: 14,
//         ),
//         prefixIcon: widget.icon != null
//             ? Icon(widget.icon, color: AppColorss.inputBorder)
//             : null,
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _obscure ? Icons.visibility_off : Icons.visibility,
//                   color: AppColorss.inputBorder,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscure = !_obscure;
//                   });
//                 },
//               )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColorss.inputBorder),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColorss.inputBorder),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         counterText: "",
//         hintText: widget.hintKey,
//         hintStyle: StyleRefer.poppinsRegular.copyWith(
//           color: AppColorss.text.withOpacity(0.6),
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';

class Textfield extends StatefulWidget {
  final String hintKey;
  final IconData? icon;
  final TextEditingController? controller;
  final bool isObscure;
  final bool isPhone;
  final bool isPassword;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? Function(String?)? validator;

  const Textfield({
    super.key,
    required this.hintKey,
    this.icon,
    this.controller,
    this.isObscure = false,
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.maxLength,
    this.validator,
    this.isPhone = false,
    this.isPassword = false,
  });

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  TextEditingController? _internalController;

  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController = widget.controller ?? _internalController!;

    return TextFormField(
      controller: effectiveController,
      obscureText: widget.isPassword ? _obscure : false,
      keyboardType: widget.inputType,
      inputFormatters: widget.isPhone
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : widget.inputFormatters,
      maxLength: widget.maxLength,
      validator: widget.validator,
      style: StyleRefer.poppinsRegular.copyWith(
        color: AppColorss.text,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        prefixText: widget.isPhone ? '+92' : null,
        prefixStyle: StyleRefer.poppinsRegular.copyWith(
          color: AppColorss.text,
          fontSize: 14,
        ),
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: AppColorss.inputBorder)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColorss.inputBorder,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColorss.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColorss.inputBorder),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        counterText: "",
        hintText: widget.hintKey,
        hintStyle: StyleRefer.poppinsRegular.copyWith(
          color: AppColorss.text.withOpacity(0.6),
          fontSize: 14,
        ),
      ),
    );
  }
}

