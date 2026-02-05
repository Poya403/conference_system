// import 'package:conference_system/utils/app_texts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class HallEventsService {
//   SupabaseClient supabase = Supabase.instance.client;
//
//   Future<List<Map<String,dynamic>>> getEventsName() async {
//     try {
//       final response = await supabase
//           .from('events')
//           .select();
//
//       return List<Map<String,dynamic>>.from(response);
//
//     } catch(e){
//       print('${AppTexts.error} $e');
//       return [];
//     }
//   }
// }