import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> translateToFrench(String englishWord) async {
  final url = Uri.parse(
    'https://api.mymemory.translated.net/get?q=$englishWord&langpair=en|fr',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['responseData']['translatedText'];
  } else {
    throw Exception('Failed to translate with MyMemory');
  }
}
