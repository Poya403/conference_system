// import 'package:conference_system/utils/app_texts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class AmenitiesService {
//   SupabaseClient supabase = Supabase.instance.client;
//
//   Future<List<Map<String,dynamic>>> getAmenities() async {
//     try {
//       final response = await supabase
//           .from('amenities')
//           .select();
//
//       return List<Map<String,dynamic>>.from(response);
//     } catch(e){
//       print('${AppTexts.error} : $e');
//       return [];
//     }
//   }
//
//   Future<List<Map<String,dynamic>>> getHallAmenities(int hid) async {
//     try {
//       final response = await supabase
//           .from('halls_amenities')
//           .select('''
//             aid,
//             hid,
//             amenities(
//               id,
//               name
//             )
//           ''')
//           .eq('hid', hid);
//       return List<Map<String,dynamic>>.from(response);
//     } catch(e){
//       print('${AppTexts.error} : $e');
//       return [];
//     }
//   }
// }