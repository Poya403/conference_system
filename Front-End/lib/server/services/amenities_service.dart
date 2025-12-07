import 'package:conference_system/utils/app_texts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AmenitiesService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String,dynamic>>> getAmenities(int hid) async {
    try {
      final response = await supabase
          .from('halls_amenities')
          .select('''
            amenity_id,
            hall_id,
            amenities(
              id,
              name
            )
          ''')
          .eq('hall_id', hid);
      return List<Map<String,dynamic>>.from(response);
    } catch(e){
      print('$AppTexts.error : $e');
      return [];
    }
  }
}