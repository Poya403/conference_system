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

      return List<Map<String, dynamic>>.from(response);

    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getSingleHall(int hid) async {
    try {
      final response = await supabase
          .from('halls')
          .select()
          .eq('id', hid)
          .single();

      return response;

    } catch (e) {
      print('${AppTexts.error} $e');
      return null;
    }
  }
}