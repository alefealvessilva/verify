import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/modules/auth/infra/datasource/i_profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/models/tenant_model.dart';
import 'package:verify/app/modules/auth/infra/models/user_model.dart';
import 'package:verify/app/modules/auth/infra/models/user_permissions_model.dart';

class SupabaseProfileDataSourceImpl implements IProfileDataSource {
  final SupabaseClient _supabase;

  SupabaseProfileDataSourceImpl(this._supabase);

  @override
  Future<UserModel> getProfile(String id) async {
    try {
      // 1. Buscar Perfil Básico
      final profileResponse = await _supabase
          .from('profiles')
          .select('id, full_name, email')
          .eq('id', id)
          .single();

      // 2. Buscar Vínculo (Membership) com o Tenant
      // Usamos join para pegar os dados do tenant junto
      final membershipResponse = await _supabase
          .from('tenant_memberships')
          .select('*, tenants(id, name, invite_code)')
          .eq('profile_id', id)
          .maybeSingle();

      if (membershipResponse != null) {
        return _mapToUserModel(
          profileResponse,
          membershipData: membershipResponse,
          tenantData: membershipResponse['tenants'],
        );
      }

      // 3. Usuário logado mas sem nenhum grupo vinculado
      return _mapToUserModel(profileResponse);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return await _createDefaultProfile(id);
      }
      rethrow;
    }
  }

  Future<UserModel> _createDefaultProfile(String id) async {
    final authUser = _supabase.auth.currentUser;
    final Map<String, dynamic> newProfile = {
      'id': id,
      'full_name': authUser?.userMetadata?['full_name'] ?? '',
      'email': authUser?.email ?? '',
    };

    final response = await _supabase
        .from('profiles')
        .upsert(newProfile)
        .select('id, full_name, email')
        .single();
    return _mapToUserModel(response);
  }

  UserModel _mapToUserModel(
    Map<String, dynamic> profileData, {
    Map<String, dynamic>? membershipData,
    Map<String, dynamic>? tenantData,
  }) {
    final authUser = _supabase.auth.currentUser;

    return UserModel(
      id: profileData['id'],
      email: profileData['email'] ?? authUser?.email ?? '',
      name: profileData['full_name'] ??
          authUser?.userMetadata?['full_name'] ??
          '',
      emailVerified: authUser?.emailConfirmedAt != null,
      tenantId: tenantData?['id'],
      role: membershipData?['role'] ?? 'none',
      status: membershipData?['status'] ?? 'none',
      // Permissões padrão baseadas no role por enquanto
      permissions: UserPermissions(
        canViewBB: membershipData?['role'] == 'admin' ||
            membershipData?['role'] == 'editor',
        canViewSicoob: membershipData?['role'] == 'admin' ||
            membershipData?['role'] == 'editor',
      ),
    );
  }

  @override
  Future<TenantModel> getTenant(String id) async {
    final response = await _supabase
        .from('tenants')
        .select('id, name, invite_code')
        .eq('id', id)
        .single();
    return TenantModel.fromMap(response);
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await _supabase.from('profiles').update({
      'full_name': user.name,
    }).eq('id', user.id);
  }

  @override
  Future<TenantModel> createTenant(String name, String adminId) async {
    final inviteCode = _generateInviteCode();

    // 1. Criar o Tenant
    final tenantResponse = await _supabase
        .from('tenants')
        .insert({
          'name': name,
          'invite_code': inviteCode,
        })
        .select()
        .single();

    final tenant = TenantModel.fromMap(tenantResponse);

    // 2. Criar a Membership (Aprovado e Admin)
    await _supabase.from('tenant_memberships').insert({
      'tenant_id': tenant.id,
      'profile_id': adminId,
      'role': 'admin',
      'status': 'approved',
    });

    return tenant;
  }

  @override
  Future<TenantModel> getTenantByInviteCode(String inviteCode) async {
    try {
      final response = await _supabase
          .from('tenants')
          .select()
          .eq('invite_code', inviteCode.trim().toUpperCase())
          .single();

      return TenantModel.fromMap(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw Exception('Código de convite inválido ou expirado.');
      }
      rethrow;
    }
  }

  @override
  Future<void> joinTenant(String tenantId, String userId) async {
    // Insere na tabela de memberships como PENDENTE
    await _supabase.from('tenant_memberships').insert({
      'tenant_id': tenantId,
      'profile_id': userId,
      'role': 'viewer',
      'status': 'pending',
    });
  }

  @override
  Future<List<UserModel>> getTenantMembers(String tenantId) async {
    final response = await _supabase
        .from('tenant_memberships')
        .select('*, profiles(id, full_name, email)')
        .eq('tenant_id', tenantId);

    return (response as List).map((data) {
      return _mapToUserModel(
        data['profiles'],
        membershipData: data,
        tenantData: {'id': tenantId},
      );
    }).toList();
  }

  @override
  Future<void> approveMember(String userId, UserPermissions permissions) async {
    // Na v2, apenas atualizamos o status para 'approved'
    // E definimos o role (ex: editor)
    await _supabase.from('tenant_memberships').update({
      'status': 'approved',
      'role': 'editor',
    }).eq('profile_id', userId);
  }

  @override
  Future<void> removeMember(String userId) async {
    await _supabase
        .from('tenant_memberships')
        .delete()
        .eq('profile_id', userId);
  }

  @override
  Future<void> cancelJoinRequest(String userId) async {
    await _supabase
        .from('tenant_memberships')
        .delete()
        .eq('profile_id', userId)
        .eq('status', 'pending');
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }
}
