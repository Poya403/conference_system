import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/utils/translator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsService{
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String,dynamic>>> getComments({int? hid, int? cid}) async {
    try {
      if (hid == null && cid == null) {
        throw Exception('Either hid or cid must be provided');
      }

      var query = supabase
          .from('comments')
          .select('''
            id,
            created_at,
            uid,
            hid,
            cid,
            text,
            score,
            profiles(
              id,
              fullname
            )
          ''');
      
      if(hid != null){
        query = query.eq('hid', hid);
      } else if(cid != null) {
        query = query.eq('cid', cid);
      }
      final response = await query;

      return List<Map<String,dynamic>>.from(response);
    } catch(e) {
      print('${AppTexts.error} : $e}');
      return [];
    }
  }

  Future<void> sendComment(
      BuildContext context, {
        int? hid,
        int? cid,
        required String text,
        int? score,
      }) async {
    final uid = supabase.auth.currentUser!.id;

    if (hid == null && cid == null) {
      throw Exception('hid or cid must be provided');
    }

    try {
      final data = <String, dynamic>{
        'text': text,
        'uid': uid,
        'score': score ?? 0,
      };

      if (hid != null) data['hid'] = hid;
      if (cid != null) data['cid'] = cid;

      await supabase.from('comments').insert(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کامنت شما با موفقیت ثبت شد')),
      );
    } catch (e) {
      final message = errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error} $message')),
      );
    }
  }

  Future<void> deleteComment(BuildContext context, int commentId) async {
    final uid = supabase.auth.currentUser!.id;

    try {
      await supabase
          .from('comments')
          .delete()
          .eq('id', commentId)
          .eq('uid', uid);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کامنت شما با موفقیت حذف شد')),
      );
    } catch (e) {
      final message = errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error} $message')),
      );
    }
  }

  Future<void> updateComment(
      BuildContext context, {
        required int commentId,
        required String text,
        int? score,
      }) async {
    final uid = supabase.auth.currentUser!.id;

    try {
      final data = <String, dynamic>{'text': text};
      if (score != null) data['score'] = score;

      await supabase
          .from('comments')
          .update(data)
          .eq('id', commentId)
          .eq('uid', uid);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کامنت شما با موفقیت ویرایش شد')),
      );
    } catch (e) {
      final message = errorTranslator(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppTexts.error} $message')),
      );
    }
  }

}