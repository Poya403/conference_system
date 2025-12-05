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
          .order('id',ascending: true);


      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> myCoursesList(String status) async {
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
          .eq('uid', uid)
          .eq('status', status);
      
      return List<Map<String,dynamic>>.from(response);

    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }

  Future<void> addShoppingBasket(BuildContext context,int cid) async {
    final SupabaseClient supabase = Supabase.instance.client;

    try{
      final request = await supabase
          .from('enrollments')
          .insert([
        { 'cid': cid },
      ]);
      print("An Item added to shopping basket: $request");

    } catch (e) {
      print('${AppTexts.error} $e');
    }
  }

  Future<void> courseRegistration(BuildContext context,int cid) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;

    try{
      final request = await supabase
          .from('enrollments')
          .update({'status': 'registered'})
          .eq('uid', uid)
          .eq('cid', cid);
      print("Registration done: $request");

    } catch (e) {
      print('${AppTexts.error} $e');
    }
  }

  Future<void> deleteCourseFromBasket(BuildContext context, int cid) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;
    try{
      final request = await supabase
          .from('enrollments')
          .delete()
          .eq('cid',cid)
          .eq('uid',uid)
          .eq('status','in_basket');

    print("Registration deleted successfully: $request");

    } catch (e) {
    print('${AppTexts.error} $e');
    }
  }
}
