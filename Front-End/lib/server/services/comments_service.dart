import 'package:conference_system/utils/app_texts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsService{
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String,dynamic>>> getHallComments(int hid) async {
    try {
      final response = await supabase
          .from('ratings_comments')
          .select('''
            created_at,
            uid,
            hid,
            text,
            score,
            profiles(
              id,
              fullName
            )
          ''')
          .eq('hid', hid);

      return List<Map<String,dynamic>>.from(response);
    } catch(e) {
      print('${AppTexts.error} : $e}');
      return [];
    }
  }
}