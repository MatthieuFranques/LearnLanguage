import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRResult {
  final String text;
  final String imagePath;

  OCRResult(this.text, this.imagePath);
}

Future<OCRResult?> pickImageAndExtractText() async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);

  if (photo == null) return null;

  final inputImage = InputImage.fromFile(File(photo.path));
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
  textRecognizer.close();

  if (recognizedText.text.isNotEmpty) {
    return OCRResult(recognizedText.text, photo.path);
  } else {
    return null;
  }
}
