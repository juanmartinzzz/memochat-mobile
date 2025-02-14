import 'package:memochat/models/group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupsService {
  // static const String _groupsKey = 'groups';

  // Add a group to Supabase
  static Future<void> addGroup(Group group) async {
    try {
      await Supabase.instance.client
          .from('groups')
          .insert({
            'id': group.id,
            'name': group.name,
            'description': group.description,
            'creator_id': group.creatorId,
          });
    } catch (e) {
      print('Error adding group ${group.id} - ${group.name} to Supabase');
      if (e is Exception) {
        print('Stack trace: ${e.toString()}');
      }
    }
  }
}
