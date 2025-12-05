import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';

class ProfileService{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProfileInfo() async {
    try {
      final response = await supabase
          .from('full_user_info')
          .select()
          .eq('id', supabase.auth.currentUser?.id as Object);

      return List<Map<String, dynamic>>.from(response);

    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }
}