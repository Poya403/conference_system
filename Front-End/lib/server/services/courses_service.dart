import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/translator.dart';

class CoursesService{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCoursesList() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final coursesResponse = await supabase
          .from('courses')
          .select();

      final basketResponse = await supabase
          .from('enrollments')
          .select('cid')
          .eq('uid', user.id);

      final basketIds = (basketResponse)
          .map<int>((e) => e['cid'] as int)
          .toSet();

      return (coursesResponse).map<Map<String, dynamic>>((course) {
        return {
          ...course,
          'isInBasket': basketIds.contains(course['id']),
        };
      }).toList();
    } catch (e) {
      print("Error in getCoursesWithBasketStatus: $e");
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
            status,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('آیتم با موفقیت به سبد خرید اضافه شد.')),
      );
    } catch (e) {
      final message = await errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error} : $message')),
      );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خرید با موفقیت انجام شد. ')),
      );

    } catch (e) {
      final message = await errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error} : $message')),
      );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('آیتم با موفقیت حذف شد.')),
      );

    } catch (e) {
      final message = await errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error}: $message')),
      );
    }
  }
}
