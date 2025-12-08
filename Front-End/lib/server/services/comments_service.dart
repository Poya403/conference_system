import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/utils/translator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsService{
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String,dynamic>>> getHallComments(int hid) async {
    try {
      final response = await supabase
          .from('comments')
          .select('''
            id,
            created_at,
            uid,
            hid,
            text,
            score,
            profiles(
              id,
              fullname
            )
          ''')
          .eq('hid', hid);
      return List<Map<String,dynamic>>.from(response);
    } catch(e) {
      print('${AppTexts.error} : $e}');
      return [];
    }
  }

  Future<void> sendComment(BuildContext context, int hid, String text, {String? score}) async{
    final uid = supabase.auth.currentUser!.id;
    try {
      await supabase.
          from('comments')
          .insert({
            'text' : text,
            'hid' : hid,
            'uid' : uid,
            'score' : score ?? 0
          });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('کامنت شما با موفقیت ثبت شد.'))
      );
    } catch (e){
      final message = errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppTexts.error} ${message}'))
      );
    }
  }

  Future<void> deleteComment(BuildContext context, int commentId) async{
    final uid = supabase.auth.currentUser!.id;
    try {
      await supabase.
        from('comments')
            .delete()
            .eq('id', commentId)
            .eq('uid', uid)
      ;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('کامنت شما با موفقیت حذف شد.'))
      );
    } catch (e){
      final message = errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppTexts.error} ${message}'))
      );
    }
  }

  Future<void> updateComment(BuildContext context, int cid, String text) async {
    SupabaseClient supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;
    try {
      await supabase
          .from('comments')
          .update({'text' : text})
          .eq('id', cid)
          .eq('uid', uid);

    } catch (e) {
      final message = errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppTexts.error} ${message}'))
      );
    }
  }
}