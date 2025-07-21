// import 'package:flutter/material.dart';
// import 'package:smart_ride/src/modules/utlis/app_fonts.dart';

// class CustomButton extends StatelessWidget {
//   final String? text;
//   final Widget? child;
//   final VoidCallback onPressed;
//   final double width;
//   final double height;
//   final Color textColor;
//   final Color backgroundColor;
//   final Color borderColor;
//   final double borderRadius;
//   final double fontSize;
//   final FontWeight fontWeight;

//   const CustomButton({
//     super.key,
//     this.text,
//     this.child,
//     required this.onPressed,
//     this.width = double.infinity,
//     this.height = 50,
//     this.textColor = Colors.white,
//     this.backgroundColor = Colors.blue,
//     this.borderColor = Colors.transparent,
//     this.borderRadius = 12,
//     this.fontSize = 16,
//     this.fontWeight = FontWeight.w500,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final content = child ??
//         Text(
//           text ?? '',
//           style: StyleRefer.poppinsSemiBold.copyWith(
//             fontSize: fontSize,
//             fontWeight: fontWeight,
//             color: textColor,
//           ),
//         );

//     return SizedBox(
//       width: width,
//       height: height,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: textColor,
//           side: BorderSide(color: borderColor),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius),
//           ),
//           elevation: 2,
//         ),
//         onPressed: onPressed,
//         child: content,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback onPressed;
  final double width;
  final double? height;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding; // ✅ New

  const CustomButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.width = double.infinity,
    this.height,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.borderColor = Colors.transparent,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.padding, // ✅ Constructor param
  });

  @override
  Widget build(BuildContext context) {
    final content = child ??
        Text(
          text ?? '',
          style: StyleRefer.poppinsSemiBold.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        );

    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.zero, // ✅ Use custom padding
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
