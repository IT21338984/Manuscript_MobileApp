import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage>
    with SingleTickerProviderStateMixin {
  File? _image;
  final picker = ImagePicker();
  String? _languagePrediction;
  String? _eraPrediction;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _languagePrediction = null;
        _eraPrediction = null;
      });
    }
  }

  Future<void> _predictImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://13.228.12.97:5000/predict'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);

        setState(() {
          _languagePrediction = data['language_predicted_class'];
          _eraPrediction = data['era_predicted_class'];
          _isLoading = false;
        });

        if (_languagePrediction == 'unknown') {
          setState(() {
            _languagePrediction = null;
            _eraPrediction = null;
          });
          Fluttertoast.showToast(
            msg: "Unknown image. Try again with a valid one.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Prediction Successful!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Server error. Try again later.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Failed to connect to the server.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4EEFF),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  title: const Text(
                    "Scan Manuscript",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                ),
                const SizedBox(height: 30),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade100,
                                Colors.deepPurple.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade100,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Upload a manuscript image to detect the era and language.',
                            style: TextStyle(
                              fontSize: 19,
                              color: Color.fromARGB(255, 49, 143, 250),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/realistic-open-parchment-scroll-transparent.png',
                        height: 200,
                      ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWideButton(Icons.photo, "Gallery", () => _pickImage(ImageSource.gallery)),
                    _buildWideButton(Icons.camera_alt, "Camera", () => _pickImage(ImageSource.camera)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPredictButton(),
                const SizedBox(height: 30),
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_languagePrediction != null && _eraPrediction != null)
                  _buildResultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideButton(IconData icon, String label, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _image == null ? null : _predictImage,
        icon: const Icon(Icons.upload),
        label: const Text("Predict"),
        style: ElevatedButton.styleFrom(
          backgroundColor: _image == null ? Colors.grey : Colors.lightBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 244, 235, 255),
            Color.fromARGB(255, 220, 198, 250),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Prediction Result:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 12),
          Text(
            "🈯 Language: $_languagePrediction",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            "🏛 Era: $_eraPrediction",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
