import 'package:google_ml_kit/google_ml_kit.dart';

class TextDetection {
  static Future<String> extractTextFromImage(InputImage inputImage) async {
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognisedText = await textRecognizer.processImage(inputImage);
    String extractedText = recognisedText.text;
    textRecognizer.close();
    return extractedText;
  }
}
