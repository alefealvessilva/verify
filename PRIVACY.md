# Política de Privacidade — Verify

**Última atualização:** 14 de abril de 2026
**Versão do aplicativo:** 1.2.3+13
**Desenvolvido por:** ASCLABS
**Pacote:** br.com.asclabs.verify

---

## 1. Introdução

O aplicativo **Verify** ("Aplicativo") é desenvolvido e mantido pela **ASCLABS**. Esta Política de Privacidade descreve como coletamos, usamos, armazenamos e protegemos seus dados pessoais quando você utiliza nosso Aplicativo.

Ao utilizar o Verify, você concorda com as práticas descritas nesta Política. Caso não concorde, recomendamos que não utilize o Aplicativo.

---

## 2. Quem Somos

- **Desenvolvedor:** ASCLABS
- **Contato:** alefeasc@gmail.com
- **Aplicativo:** Verify — Gerenciador de Cobranças Pix

---

## 3. Dados Coletados

### 3.1 Dados fornecidos pelo usuário

- **Credenciais de acesso:** e-mail e senha utilizados para autenticação no Aplicativo.
- **Credenciais bancárias:** chaves de acesso (Client ID e Client Secret) das APIs do **Banco do Brasil** e **Sicoob**, fornecidas voluntariamente pelo usuário para consulta de cobranças Pix. Essas credenciais são armazenadas localmente no dispositivo com criptografia.

### 3.2 Dados coletados automaticamente

- **Identificadores de dispositivo:** utilizados pelo serviço de anúncios Google AdMob para exibição de publicidade personalizada.
- **Dados de uso:** informações sobre interações com o Aplicativo (telas acessadas, erros), coletadas anonimamente pelo Supabase para fins de diagnóstico e melhoria do serviço.

### 3.3 Dados de transações financeiras

- O Aplicativo **não armazena dados de transações Pix** em servidores próprios. As informações de cobranças são consultadas diretamente nas APIs do Banco do Brasil e do Sicoob em tempo real e exibidas apenas na tela do usuário.

---

## 4. Uso dos Dados

Os dados coletados são utilizados exclusivamente para:

| Finalidade | Base Legal |
|---|---|
| Autenticar o usuário no Aplicativo | Execução de contrato |
| Consultar cobranças Pix nas APIs bancárias | Execução de contrato |
| Armazenar preferências locais do usuário | Legítimo interesse |
| Exibir anúncios relevantes via Google AdMob | Consentimento |
| Diagnosticar erros e melhorar o Aplicativo | Legítimo interesse |

---

## 5. Compartilhamento de Dados

Não vendemos, alugamos nem compartilhamos seus dados pessoais com terceiros, **exceto** nos seguintes casos:

### 5.1 APIs Bancárias
- **Banco do Brasil** e **Sicoob**: as credenciais e requisições são enviadas diretamente às APIs oficiais dessas instituições para consulta de cobranças. Consulte as políticas de privacidade de cada instituição:
  - [Banco do Brasil — Privacidade](https://www.bb.com.br/privacidade)
  - [Sicoob — Privacidade](https://www.sicoob.com.br/web/sicoob/privacidade)

### 5.2 Serviços de Infraestrutura
- **Supabase** (supabase.com): utilizado para autenticação de usuários e armazenamento de configurações. Os dados são processados conforme a [Política de Privacidade do Supabase](https://supabase.com/privacy).

### 5.3 Publicidade
- **Google AdMob** (Google LLC): utilizado para exibição de anúncios. O Google pode coletar identificadores de dispositivo para personalização de anúncios. Consulte a [Política de Privacidade do Google](https://policies.google.com/privacy).

### 5.4 Obrigações Legais
Podemos divulgar informações quando exigido por lei, regulamentação ou decisão judicial.

---

## 6. Armazenamento e Segurança

- **Credenciais bancárias** (Client ID e Client Secret) são armazenadas **localmente no dispositivo** utilizando armazenamento seguro criptografado (`flutter_secure_storage`). Elas **não são transmitidas** para servidores da ASCLABS.
- **Dados de autenticação** são gerenciados pelo Supabase com criptografia em trânsito (TLS) e em repouso.
- Adotamos práticas de segurança e desenvolvimento seguros, incluindo o uso de variáveis de ambiente para proteger chaves de API.

---

## 7. Retenção de Dados

- **Dados locais:** permanecem no dispositivo até que o usuário desinstale o Aplicativo ou limpe os dados manualmente.
- **Dados de autenticação (Supabase):** mantidos enquanto a conta estiver ativa.
- Você pode solicitar a exclusão da sua conta e dados a qualquer momento pelo e-mail de contato.

---

## 8. Direitos do Usuário (LGPD)

Nos termos da **Lei Geral de Proteção de Dados (Lei nº 13.709/2018)**, você tem os seguintes direitos:

- ✅ **Confirmação** de que seus dados são tratados
- ✅ **Acesso** aos dados pessoais que possuímos
- ✅ **Correção** de dados incompletos ou incorretos
- ✅ **Anonimização, bloqueio ou eliminação** de dados desnecessários
- ✅ **Portabilidade** dos seus dados
- ✅ **Eliminação** dos dados tratados com base em consentimento
- ✅ **Revogação do consentimento** a qualquer momento

Para exercer qualquer um desses direitos, entre em contato pelo e-mail: **alefeasc@gmail.com**

---

## 9. Publicidade e Controle de Anúncios

O Aplicativo utiliza o **Google AdMob** para exibição de anúncios. Para gerenciar suas preferências de publicidade personalizada, acesse:

- **Android:** Configurações → Google → Anúncios → Desativar personalização de anúncios
- Ou acesse: [https://adssettings.google.com](https://adssettings.google.com)

---

## 10. Privacidade de Menores

O Verify **não é destinado a crianças** menores de 18 anos. Não coletamos intencionalmente dados pessoais de menores de idade. Se tomarmos conhecimento de tal coleta, os dados serão imediatamente excluídos.

---

## 11. Alterações nesta Política

Podemos atualizar esta Política de Privacidade periodicamente. Notificaremos sobre mudanças significativas por meio de uma atualização no Aplicativo. A data da última atualização estará sempre indicada no topo deste documento.

---

## 12. Contato

Dúvidas, solicitações ou reclamações relacionadas à privacidade:

- **E-mail:** alefeasc@gmail.com
- **Desenvolvedor:** ASCLABS
- **Aplicativo:** Verify — `br.com.asclabs.verify`

---

*Esta Política de Privacidade foi elaborada em conformidade com a Lei Geral de Proteção de Dados (LGPD — Lei nº 13.709/2018) e as diretrizes da Google Play Store.*
