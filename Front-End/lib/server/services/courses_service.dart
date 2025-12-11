import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/translator.dart';

class CoursesService{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCoursesList() async {
    try {
      final response = await supabase
          .rpc('get_unregistered_courses')
          .select();

      return List<Map<String,dynamic>>.from(response as List);
    } catch (e) {
      print("Error in getCoursesWithBasketStatus: $e");
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> myCoursesList(String status) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;
    final PostgrestList response;
    try {
      if(status == "own courses"){
        response = await supabase
            .from('courses')
            .select('''
                id,
                title,
                registrants,
                cost,
                phone_number,
                delivery_type,
                uid,
                start_time,
                end_time,
                created_at
            ''')
            .eq('uid', uid);
      } else {
        response = await supabase
            .from('enrollments')
            .select('''
              uid,
              cid,
              status,
              courses (
                id,
                title,
                registrants,
                delivery_type,
                start_time,
                end_time
              )
            ''')
            .eq('uid', uid)
            .eq('status', status);
      }

      return List<Map<String,dynamic>>.from(response);
    } catch (e) {
      return [];
    }

  }

  Future<void> addShoppingBasket(BuildContext context,int cid) async {
    final SupabaseClient supabase = Supabase.instance.client;

    try{
       await supabase
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
      await supabase
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
      await supabase
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

  Future<List<Map<String, dynamic>>> getBestHalls({
    required String eventType,
    required int expectedCapacity,
    required double budget,
    required List<String> requiredAmenities,
  }) async {
    final supabase = Supabase.instance.client;

    final best = await supabase.rpc(
      'get_best_halls',
      params: {
        'p_event_type': eventType,
        'p_expected_capacity': expectedCapacity,
        'p_budget': budget,
        'p_required_amenities': requiredAmenities,
      },
    );

    if (best == null || best.isEmpty) return [];

    final ids = (best as List<dynamic>)
        .map((e) => e['hid'] as int)
        .toList();

    final halls = await supabase
        .from('halls')
        .select()
        .inFilter('halls.id', ids);

    return halls;
  }


}
