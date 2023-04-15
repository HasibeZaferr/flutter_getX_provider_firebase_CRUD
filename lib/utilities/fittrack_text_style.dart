import 'package:flutter/material.dart';
import 'package:flutter_fittrack/utilities/fittrack_colors.dart';
import 'fittrack_size.dart';

class FittrackTextStyle {
  static TextStyle appBarTextStyle({
    Color color = kColorAppBarTitle,
    double fontSize = kFontSizeAppBarText,
    FontWeight fontWeight = FontWeight.w700,
    bool isBold = true,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : fontWeight,
    );
  }


  static TextStyle pageTitleStyle({
    Color color = kColorPageTitle,
    double fontSize = kFontSizePageTitleText,
    bool isBold = false,
    FontWeight fontWeight = FontWeight.w700,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : fontWeight,
      decoration: decoration,
    );
  }

  static TextStyle pageDescriptionTextStyle({
    Color color = kColorPageDescription,
    double fontSize = kFontSizePageDescriptionText,
    FontWeight fontWeight = FontWeight.w400,
    bool isBold = true,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : fontWeight,
    );
  }

  static TextStyle defaultTextStyle({
    Color color = kColorDayListText,
    double fontSize = kFontSizeDefaultText,
    FontWeight fontWeight = FontWeight.w700,
    bool isBold = true,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : fontWeight,
    );
  }

  static TextStyle hintTextStyle({
    Color color = kColorHintText,
    double fontSize = kFontSizeHintText,
    FontWeight fontWeight = FontWeight.w400,
    bool isBold = false,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : fontWeight,
    );
  }
}
