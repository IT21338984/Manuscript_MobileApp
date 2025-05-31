import 'package:flutter/material.dart';
import 'colors.dart';

// AppBar Style
const AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: colorDarkBlue,
  iconTheme: IconThemeData(color: colorLightBlue),
  toolbarHeight: 80,
);

const TextStyle mainText = TextStyle(
  color: colorBrightBlue,
  fontFamily: 'Outfit',
  letterSpacing: 2.0,
  fontSize: 30.0,
  fontWeight: FontWeight.w800,
);

const TextStyle secondaryText = TextStyle(
  color: colorBrightBlue,
  fontFamily: 'Outfit',
  letterSpacing: 1.0,
  fontSize: 25.0,
  fontWeight: FontWeight.w800,
);

const thirdText = TextStyle(
  color: colorLightBlue,
  fontFamily: 'Outfit',
  letterSpacing: 1.0,
  fontSize: 25.0,
  fontWeight: FontWeight.w600,
);

const TextStyle warnText = TextStyle(
  color: colorRed,
  fontFamily: 'Outfit',
  letterSpacing: 2.0,
  fontSize: 30.0,
  fontWeight: FontWeight.w800,
);

final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: colorLightBlue,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  ),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: colorMutedBlue,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  ),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: colorBrightBlue,
  side: const BorderSide(color: colorBrightBlue, width: 2),
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
  ),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final ButtonStyle textButtonStyle = TextButton.styleFrom(
  foregroundColor: colorLightBlue,
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);

final ButtonStyle dangerButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: colorRed,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  ),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final InputDecoration inputFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: colorDarkBlue, width: 1.5),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: colorLightBlue, width: 1.5),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: colorLightBlue, width: 2.0),
  ),
  labelStyle: const TextStyle(
    color: colorDarkBlue,
    fontFamily: 'Outfit',
    letterSpacing: 2.0,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: colorRed, width: 1.5),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: colorRed, width: 2.0),
  ),
);
