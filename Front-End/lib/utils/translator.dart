import 'package:translator/translator.dart';

Future<String> errorTranslator(String rawMessage) async {
  if(rawMessage.contains('duplicate key value')){
    return 'شما قبلاً این دوره را به سبد خرید اضافه کرده‌اید.';
  }
  final translator = GoogleTranslator();
  String message = rawMessage;

  if(rawMessage.contains('message:')){
    message = rawMessage.split('message:')[1].trim();
  }
  final translation = await translator.translate(message, to: 'fa');
  return translation.text;
}