import 'package:flutter/cupertino.dart';
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

  Future<void> courseRegistration(BuildContext context,int cid) async {
    final SupabaseClient supabase = Supabase.instance.client;

    try{
      final request = await supabase
          .from('enrollments')
          .insert([
        { 'cid': cid },
      ]);
      print("Registration done: $request");

    } catch (e) {
      print('${AppTexts.error} $e');
    }
  }

  Future<List<Map<String,dynamic>>> myCoursesList() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;

    try{
      final response = await supabase
          .from('enrollments')
          .select('''
            uid,
            cid,
            courses (
              id,
              title,
              registrants,
              type
            )
          ''')
          .eq('uid', uid);
      
      return List<Map<String,dynamic>>.from(response);

    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }

  Future<void> deleteCourse(BuildContext context, int cid) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;
    try{
      final request = await supabase
          .from('enrollments')
          .delete()
          .eq('cid',cid)
          .eq('uid',uid);

    print("Registration done: $request");

    } catch (e) {
    print('${AppTexts.error} $e');
    }
  }
}
