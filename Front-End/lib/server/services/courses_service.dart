import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/translator.dart';
import 'package:conference_system/models/course_filter.dart';

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
                hid,
                start_time,
                end_time,
                created_at,
                halls(
                  id,
                  title
                )
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

  Future<void> createCourse(
      BuildContext context,
      String title,
      String deliveryType,
      DateTime startTime,
      DateTime endTime,
      String phoneNumber,
      int cost,
      String description,
      {int? hid}
      ) async {
    final uid = supabase.auth.currentUser!.id;

    try {
      await supabase
        .from('courses')
        .insert({
          'title' : title,
          'delivery_type' : deliveryType,
          'start_time': startTime.toIso8601String(),
          'end_time' : endTime.toIso8601String(),
          'phone_number': phoneNumber,
          'cost': cost,
          'description': description,
          'hid' : hid,
          'uid' : uid,
        });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("َدوره با موفقیت ثبت شد"))
      );
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' : خطا در ثبت دوره$e'))
      );
    }
  }

  Future<void> updateCourse(
      BuildContext context,
      int cid,
      String title,
      String deliveryType,
      String startTime,
      String endTime,
      String phoneNumber,
      int cost,
      String description,
      {int? hid}
      ) async {
    final uid = supabase.auth.currentUser!.id;

    try {
      await supabase
        .from('courses')
        .update({
          'title' : title,
          'delivery_type' : deliveryType,
          'start_time': startTime,
          'end_time' : endTime,
          'phone_number': phoneNumber,
          'cost': cost,
          'description': description,
          'hid' : hid,
        })
        .eq('id', cid)
        .eq('uid', uid);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("َدوره با موفقیت ویرایش شد"))
      );
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' : خطا در ویرایش دوره$e'))
      );
    }
  }

  Future<List<Map<String,dynamic>>> getBestHalls({
    required String eventType,
    required int expectedCapacity,
    required double budget,
    required List<String> requiredAmenities,
  }) async {
    final response = await supabase.rpc(
      'get_best_hall_list',
      params: {
        'p_event_type': eventType,
        'p_expected_capacity': expectedCapacity,
        'p_budget': budget,
        'p_required_amenities': requiredAmenities,
      },
    );

    return (response as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<List<Map<String, dynamic>>> searchCourse(CourseFilter filter) async {
    try {
      final response = await supabase
          .rpc('get_unregistered_courses',
        params: {
          'p_search': filter.search,
          'p_hid': filter.hid,
          'p_min_cost': filter.minPrice ?? 0,
          'p_max_cost': filter.maxPrice ?? 1000000,
        },
      ).select();

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print("Error in searchCourse: $e");
      return [];
    }
  }

}
