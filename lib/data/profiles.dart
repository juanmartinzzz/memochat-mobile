import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilesService {
  static Future<String> getEmoji({required String userId}) async {
    final response = await Supabase.instance.client.from('profiles').select('emoji').eq('id', userId);

    return response.first['emoji'];
  }
}
