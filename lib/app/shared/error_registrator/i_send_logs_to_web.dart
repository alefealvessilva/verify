// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:verify/app/shared/services/client_service/i_client_service.dart';

abstract class ISendLogsToWeb {
  Future<void> call(Object e);
}

class SendLogsToDiscordChannel implements ISendLogsToWeb {
  final IClientService _clientService;
  SendLogsToDiscordChannel(
    this._clientService,
  );
  @override
  Future<void> call(Object e) async {
    final webhookUrl = dotenv.env['DISCORD_WEBHOOK_URL'];
    if (webhookUrl == null || webhookUrl.trim().isEmpty) return;

    try {
      // Não usamos mais o UseCase aqui para evitar a recursão infinita (Auth -> Log -> Auth)
      final userId = Supabase.instance.client.auth.currentUser?.id ?? 'Deslogado';

      // Envio "Fire and Forget" para não travar o fluxo principal
      await _clientService.post(
        url: webhookUrl,
        body: {'content': '```diff\n+ UserID: $userId\n- Error: $e \n```'},
      ).timeout(const Duration(seconds: 2));
    } catch (_) {
      // Falha silenciosa para não quebrar o fluxo da aplicação
    }
  }
}
