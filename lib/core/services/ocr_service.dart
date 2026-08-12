import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:slipscanner/features/home/presentation/screens/sheet_screen.dart';
import 'package:image_picker/image_picker.dart';


class MlKitService{
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<List<String>> processImageBatch(List<String> imagePath) async {
    List<String> results = [];
    for (String path in imagePath){
      try{
        final text = await processImageBatch(path as List<String>);
        results.add(text as String);
      } catch (e){
        results.add("Metin Okunamadı");
      }
    }
    return results;
  }

}