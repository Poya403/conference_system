import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';

class CoursesService{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCoursesLists() async {
    try {
      final response = await supabase
          .from('courses')
          .select('''
            id,
            title,
            cost,
            hid,
            registrants,
            type,
            halls (
              id,
              title,
              city,
              capacity
            )
          ''')
          .order('id');


      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }
}