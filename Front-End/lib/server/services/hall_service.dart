import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';

class HallService{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getHallLists() async {
    try {
      final response = await supabase
          .from('halls')
          .select()
          .order('date', ascending: true);

      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        return [];
      }
    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }
}