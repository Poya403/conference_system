import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/utils/translator.dart';

class ProfileService{
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProfileInfo() async {
    try {
      final response = await supabase
          .from('full_user_info')
          .select()
          .eq('id', supabase.auth.currentUser?.id as Object);

      return List<Map<String, dynamic>>.from(response);

    } catch (e) {
      print('${AppTexts.error} $e');
      return [];
    }
  }

  Future<void> updateProfileInfo(BuildContext context, String fullName, String bio) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;

    try{
      await supabase
          .from('profiles')
          .update({
            'fullname' : fullName,
            'bio' : bio,
          })
          .eq('id', uid);

    } catch(e) {
      final message = await errorTranslator(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error} : $message')),
      );
    }
  }
}