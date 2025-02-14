import 'package:memochat/environment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  // Initialize SupabaseFlutter
  static Future<void> initialize() async {
    // Supabase auth variables
    final url = Environment.supabaseUrl;
    final anonKey = Environment.supabaseAnonKey;
    // print('Initializing Supabase with URL: $url and anonKey: $anonKey');

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}
