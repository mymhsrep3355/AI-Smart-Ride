import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_ride/src/modules/utlis/app_colors.dart';
import 'package:smart_ride/src/modules/utlis/app_fonts.dart';



enum ActionStyle { normal, destructive, important, important_destructive }

class AppDialog {
  static const Color _normal = AppColors.borderColor;
  static const Color _destructive = Colors.red;

  /// show the OS Native dialog
  showOSDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallBack,
      {ActionStyle firstActionStyle = ActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ActionStyle secondActionStyle = ActionStyle.normal}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return WillPopScope(
            onWillPop: () async => false,
            child: _iosDialog(
                context, title, message, firstButtonText, firstCallBack,
                firstActionStyle: firstActionStyle,
                secondButtonText: secondButtonText ?? '',
                secondCallback: secondCallback ?? () {},
                secondActionStyle: secondActionStyle),
          );
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: _androidDialog(
                context, title, message, firstButtonText, firstCallBack,
                firstActionStyle: firstActionStyle,
                secondButtonText: secondButtonText ?? '',
                secondCallback: secondCallback ?? () {},
                secondActionStyle: secondActionStyle),
          );
        }
      },
    );
  }

  /// show the android Native dialog
  Widget _androidDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallBack,
      {ActionStyle firstActionStyle = ActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ActionStyle secondActionStyle = ActionStyle.normal}) {
    List<TextButton> actions = [];
    actions.add(TextButton(
      child: Text(
        firstButtonText,
        style: TextStyle(
            color: (firstActionStyle == ActionStyle.important_destructive ||
                    firstActionStyle == ActionStyle.destructive)
                ? _destructive
                : _normal,
            fontWeight:
                (firstActionStyle == ActionStyle.important_destructive ||
                        firstActionStyle == ActionStyle.important)
                    ? FontWeight.bold
                    : FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        firstCallBack();
      },
    ));

    if ((secondButtonText ?? '').isNotEmpty) {
      actions.add(TextButton(
        child: Text(secondButtonText ?? '',
            style: TextStyle(
                color:
                    (secondActionStyle == ActionStyle.important_destructive ||
                            firstActionStyle == ActionStyle.destructive)
                        ? _destructive
                        : _normal)),
        onPressed: () {
          Navigator.of(context).pop();
          secondCallback!();
        },
      ));
    }

    return AlertDialog(
        title: Text(title), content: Text(message), actions: actions);
  }

  /// show the iOS Native dialog
  Widget _iosDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallback,
      {ActionStyle firstActionStyle = ActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ActionStyle secondActionStyle = ActionStyle.normal}) {
    List<CupertinoDialogAction> actions = [];
    actions.add(
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.of(context).pop();
          firstCallback();
        },
        child: Text(
          firstButtonText,
          style: TextStyle(
              color: (firstActionStyle == ActionStyle.important_destructive ||
                      firstActionStyle == ActionStyle.destructive)
                  ? _destructive
                  : _normal,
              fontWeight:
                  (firstActionStyle == ActionStyle.important_destructive ||
                          firstActionStyle == ActionStyle.important)
                      ? FontWeight.bold
                      : FontWeight.normal),
        ),
      ),
    );

    if ((secondButtonText ?? '').isNotEmpty) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            secondCallback!();
          },
          child: Text(
            secondButtonText ?? '',
            style: TextStyle(
                color:
                    (secondActionStyle == ActionStyle.important_destructive ||
                            secondActionStyle == ActionStyle.destructive)
                        ? _destructive
                        : _normal,
                fontWeight:
                    (secondActionStyle == ActionStyle.important_destructive ||
                            secondActionStyle == ActionStyle.important)
                        ? FontWeight.bold
                        : FontWeight.normal),
          ),
        ),
      );
    }

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions,
    );
  }
}

class ResponseDialog {
  static showError(String errorMessage, [VoidCallback? onClick]) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text(
                  "error",
                  style: StyleRefer.poppinsSemiBold,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  errorMessage,
                  style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 12),
                ),
                actions: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primary),
                    ),
                    child: Text(
                      "ok",
                      style: StyleRefer.poppinsSemiBold.copyWith(
                        color:Colors.white,
                      ),
                    ),
                    onPressed: () {
                      onClick != null ? onClick() : Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text(
                  "error",
                ),
                content: Text(
                  errorMessage,
                  style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 12),
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      onClick != null ? onClick() : Navigator.of(context).pop();
                    },
                    child: Text(
                      "ok",
                      style: StyleRefer.poppinsSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              );
      },
    );
  }

  static void showSuccess(String message, [VoidCallback? onClick]) {
    showDialog(
      context: Get.context!,
      barrierDismissible: onClick != null ? false : true,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text(
                  "success",
                  style: StyleRefer.poppinsSemiBold,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  message,
                  style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 12),
                ),
                actions: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primary),
                    ),
                    onPressed: () {
                      onClick != null ? onClick() : Navigator.of(context).pop();
                    },
                    child: Text(
                      "ok",
                      style: StyleRefer.poppinsSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text(
                  "success",
                  style: StyleRefer.poppinsSemiBold
                      .copyWith(color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  message,
                  style: StyleRefer.poppinsSemiBold.copyWith(fontSize: 12),
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      onClick != null ? onClick() : Navigator.of(context).pop();
                    },
                    child: Text(
                      "ok",
                      style: StyleRefer.poppinsSemiBold.copyWith(
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              );
      },
    );
  }

  static void showSuccessWithLogo(String message, [VoidCallback? onClick]) {
    showDialog(
      context: Get.context!,
      barrierDismissible: onClick != null ? false : true,
      builder: (BuildContext context) {
        Widget image = Image.asset(
          'assets/png/app_icon.png',
          height: 40,
          width: 40,
        );
        return Platform.isAndroid
            ? AlertDialog(
                title: image,
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text("ok"),
                    onPressed: () {
                      onClick != null ? onClick() : Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: image,
                content: Text(message),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      onClick != null ? onClick() : Navigator.of(context).pop();
                    },
                    child: const Text(
                      "ok",
                    ),
                  )
                ],
              );
      },
    );
  }
}
