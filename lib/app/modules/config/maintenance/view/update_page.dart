import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ota_update/ota_update.dart';
import 'package:verify/app/core/remote_config_store.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String _progress = '0';
  bool _isDownloading = false;
  String _status = 'Uma nova versão está disponível!';

  Future<void> _startUpdate() async {
    final remoteConfig = Modular.get<RemoteConfigStore>();
    if (remoteConfig.apkUrl == null || remoteConfig.apkUrl!.isEmpty) return;

    setState(() {
      _isDownloading = true;
      _status = 'Baixando atualização...';
    });

    try {
      OtaUpdate().execute(
        remoteConfig.apkUrl!,
        destinationFilename: 'verify_update.apk',
      ).listen(
        (OtaEvent event) {
          setState(() {
            _progress = event.value ?? '0';
            if (event.status == OtaStatus.INSTALLING) {
               _status = 'Instalando...';
               _isDownloading = false;
            } else if (event.status == OtaStatus.DOWNLOADING) {
               _status = 'Baixando: $_progress%';
            }
          });
        },
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _status = 'Erro no download. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final remoteConfig = Modular.get<RemoteConfigStore>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update_rounded,
                  size: 80,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Nova Versão : ${remoteConfig.latestVersion}',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              if (_isDownloading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: double.tryParse(_progress) != null ? double.parse(_progress) / 100 : 0,
                      backgroundColor: colorScheme.surfaceContainer,
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      minHeight: 12,
                    ),
                    const SizedBox(height: 16),
                    Text('$_progress%', style: theme.textTheme.titleMedium),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _startUpdate,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Atualizar Agora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
              const SizedBox(height: 32),
              Text(
                'Mantenha o app atualizado para garantir sua segurança.',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
