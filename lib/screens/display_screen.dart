import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  static const String _prompt =
      'Which animal does the person in this picture most resemble? Please answer only the name of the animal.';
  dynamic _response = '';
  dynamic _imageResponse = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Container(color: Colors.black)),
          Expanded(
            flex: 6,
            child: _response == ''
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.imagePath,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(
                          _imageResponse,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      // Gemini TEST
                      const apiKey = 'Enter_your_API_KEY';
                      if (apiKey == null) {
                        print('No \$API_KEY environment variable');
                        exit(1);
                      }
                      // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
                      final model = GenerativeModel(
                          model: 'gemini-1.5-flash', apiKey: apiKey);
                      final imageFile =
                          await XFile(widget.imagePath).readAsBytes();
                      final prompt = TextPart(_prompt);
                      final imageParts = [
                        DataPart('image/jpeg', imageFile),
                      ];
                      final response = await model.generateContent([
                        Content.multi([prompt, ...imageParts])
                      ]);

                      final url =
                          'https://image.pollinations.ai/prompt/japan-animated-cute-${response.text}';
                      final imageResponse = await http.get(Uri.parse(url));
                      setState(() {
                        _imageResponse = imageResponse.bodyBytes;
                        _response = response.text;
                        _isLoading = false;
                      });
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(_response == '' ? '분석' : _response,
                            style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
