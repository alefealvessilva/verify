// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/shared/error_registrator/discord_webhook_url.dart';
import 'package:verify/app/shared/services/client_service/client_service.dart';

abstract class SendLogsToWeb {
  Future<void> call(Object e);
}

class SendLogsToDiscordChannel implements SendLogsToWeb {
  final ClientService _clientService;
  SendLogsToDiscordChannel(
    this._clientService,
  );
  @override
  Future<void> call(Object e) async {
    // Não usamos mais o UseCase aqui para evitar a recursão infinita (Auth -> Log -> Auth)
    final userId = Supabase.instance.client.auth.currentUser?.id ?? 'Deslogado';

    // Envio "Fire and Forget" para não travar o fluxo principal
    _clientService.post(
      url: discordWebookUrl,
      body: {'content': '```diff\n+ UserID: $userId\n- Error: $e \n```'},
    ).timeout(const Duration(seconds: 2), onTimeout: () => null);
  }
}
