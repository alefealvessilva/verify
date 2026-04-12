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
