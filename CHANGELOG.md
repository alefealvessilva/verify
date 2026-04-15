## [1.3.0+14] - 15-04-2026

### Removido
- Lógica de atualização remota (OTA via Supabase e GitHub) agora que temos acesso ao Play Console.
- Permissões Android desnecessárias (`READ_EXTERNAL_STORAGE`, `REQUEST_INSTALL_PACKAGES`) para maior privacidade e conformidade.
- `FileProvider` e configurações de caminhos associadas.

### Alterado
- Incremento de versão e preparação para produção (Play Store Bundle).
- Otimização de build com Minificação e ShrinkResources no Android.

## [1.2.3+13] - 14-04-2026

### Alterado
- Migração do package name de `br.com.acxtech.verify` para `br.com.asclabs.verify`.
- Resolução de conflitos de Content Provider Authority (`androidx-startup` e `mobileadsinitprovider`) no `AndroidManifest.xml`.

## [1.2.3+11] - 12-04-2026

### Corrigido
- Erro crítico de fuso horário nas transações (exibição de 10:05/04:05 em vez de 07:05).
- Erro de busca de transações no Banco do Brasil (erro 4769515) ajustando o cálculo do intervalo de datas.

## [1.2.2+10] - 11-04-2026

### Adicionado
- Implementação de variáveis de ambiente (`.env`) para maior segurança das chaves do Supabase.
- Configuração de assinatura de release para Android (Keystore).
- Integração com GitHub Releases para atualizações OTA (Over-The-Air).

### Corrigido
- Bug de navegação "travada" na tela de login após ciclo de logout/login.
- Lógica de redirecionamento reativo na `AppWidget` usando `autorun`.
- Unificação do fluxo de logout na `AuthStore` para garantir limpeza de estado.

### Segurança
- Migração de credenciais sensíveis da `main.dart` para o contexto de variáveis de ambiente.

## [1.2.2+9] - 01-05-2023

- Fixed issues

## [1.1.1+5] - 24-04-2023

- Launched Open Beta version
