import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 🔐 Verifica se o usuário logado é administrador
  Future<bool> isAdmin(String authUserId) async {
    try {
      final response = await _client
          .from('usuarios')
          .select('is_admin')
          .eq('auth_user_id', authUserId)
          .single();

      return response['is_admin'] == true;
    } catch (e) {
      // 🔒 Segurança: se der erro, NÃO é admin
      return false;
    }
  }

  /// 📋 Busca nome completo do usuário
  Future<String?> buscarNomeUsuario(String authUserId) async {
    try {
      final response = await _client
          .from('usuarios')
          .select('nome_completo')
          .eq('auth_user_id', authUserId)
          .single();

      return response['nome_completo'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// 🚫 Bloquear / desbloquear usuário
  Future<void> setBloqueado({
    required String authUserId,
    required bool bloqueado,
  }) async {
    await _client
        .from('usuarios')
        .update({'bloqueado': bloqueado})
        .eq('auth_user_id', authUserId);
  }

  /// 🗑️ Excluir usuário (somente tabela, Auth exige Edge Function)
  Future<void> excluirUsuario(String authUserId) async {
    await _client
        .from('usuarios')
        .delete()
        .eq('auth_user_id', authUserId);
  }
}