import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manuscript/const/colors.dart';
import 'package:manuscript/const/styles.dart';

class ResultScreen extends StatelessWidget {
  final File image;
  final String language;
  final String era;

  const ResultScreen({
    Key? key,
    required this.image,
    required this.language,
    required this.era,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        centerTitle: true,
        title: Row(
          children: [
            Image.asset('assets/logo.jpg', height: 40),
            const SizedBox(width: 30.0),
            Text(
              'Predictions',
              style: mainText.copyWith(
                fontWeight: FontWeight.w600,
                color: colorLightBlue,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Resized Image for Uniform Display
              Container(
                width: 350, // Set a fixed width
                height: 250, // Set a fixed height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: colorLightBlue, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(
                    image,
                    fit: BoxFit.cover, // Maintain aspect ratio
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Box for Language Prediction
              Container(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Add padding inside the box
                decoration: BoxDecoration(
                  color: colorLightBlue.withOpacity(
                    0.1,
                  ), // Light background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  border: Border.all(color: colorLightBlue, width: 1), // Border
                ),
                child: Text(
                  'Language: $language',
                  style: secondaryText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorLightBlue,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// Box for Era Prediction
              Container(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Add padding inside the box
                decoration: BoxDecoration(
                  color: colorLightBlue.withOpacity(
                    0.1,
                  ), // Light background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  border: Border.all(color: colorLightBlue, width: 1), // Border
                ),
                child: Text(
                  'Era: $era',
                  style: thirdText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 53, 155, 157),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
