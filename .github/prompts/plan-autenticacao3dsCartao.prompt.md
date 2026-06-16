**Plano**
A descoberta mostrou três fatos que mudam o desenho: o fluxo de cartão hoje é um único submit síncrono em [lib/presentation/payment/state/card_payment_notifier.dart](lib/presentation/payment/state/card_payment_notifier.dart), não existe infraestrutura pronta para WebView, deep link ou bridge nativo em [pubspec.yaml](pubspec.yaml), [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) e [ios/Runner/Info.plist](ios/Runner/Info.plist), e a fila offline atual é apenas em memória em [lib/common/api_config/api_request_queue.dart](lib/common/api_config/api_request_queue.dart), então 3DS precisa ser tratado como fluxo estritamente online. Com base no que você respondeu, a recomendação é backend-first: o app fala só com a API atual, o gateway orquestra o 3DS no servidor, e o mobile executa o challenge por WebView se a documentação oficial permitir; se não permitir, o plano já deixa preparado o fallback para SDK nativo.

1. Fase 1, contrato e decisão técnica: fechar com backend/gateway o contrato 3DS para crédito e débito, incluindo transactionId, estados intermediários, timeout, idempotência, retorno final e payload do challenge. Aqui sai a decisão objetiva entre WebView e SDK nativo.
2. Fase 1, state machine do app: substituir o modelo atual de sucesso/erro por estados explícitos como submitting, pending3ds, challengeInProgress, verifying, authorized, denied, cancelled e expired. Isso evita acoplamento do fluxo 3DS ao comportamento atual de pagamento imediato.
3. Fase 2, contrato mobile de dados: enriquecer o retorno de cartão para carregar challengeUrl ou sdkPayload, callbackUrl, status 3DS e códigos de erro. Se o backend preferir rotas separadas, prever iniciar challenge, consultar status e retomar sessão em [lib/common/api_config/api_routes.dart](lib/common/api_config/api_routes.dart).
4. Fase 2, regra online-only: no fluxo 3DS, desabilitar a fila offline no ponto de chamada em [lib/data/data/payment/payment_data_source.dart](lib/data/data/payment/payment_data_source.dart), aproveitando a flag já existente em [lib/common/api_config/api_service.dart](lib/common/api_config/api_service.dart). Sem internet, o fluxo deve falhar antes do challenge, não enfileirar.
5. Fase 2, data e domain: expandir modelos e entidades em [lib/data/models/payment](lib/data/models/payment), [lib/domain/entity/payment](lib/domain/entity/payment) e [lib/domain/usecases/payment/payment_usecase.dart](lib/domain/usecases/payment/payment_usecase.dart), mantendo a conversão DataModel para Entity no use case. Se o contrato ficar grande, vale criar um use case dedicado para 3DS em vez de inflar o fluxo atual.
6. Fase 3, orquestração no presentation layer: refatorar CardPaymentNotifier.submitPayment em [lib/presentation/payment/state/card_payment_notifier.dart](lib/presentation/payment/state/card_payment_notifier.dart) para disparar o challenge, aguardar retorno, consultar confirmação final no backend e só então limpar carrinho e invalidar providers. Hoje isso acontece cedo demais para um fluxo 3DS.
7. Fase 3, estado da tela: expandir [lib/presentation/payment/state/card_payment_state.dart](lib/presentation/payment/state/card_payment_state.dart) para armazenar contexto do challenge, resultado intermediário, erros transacionais e retomada. O estado atual é pequeno demais para 3DS.
8. Fase 3, navegação: criar uma rota dedicada de challenge em [lib/common/routing/router_config.dart](lib/common/routing/router_config.dart) e registrar o nome em [lib/common/routing/route_names.dart](lib/common/routing/route_names.dart). A tela de cartão em [lib/presentation/payment/pages/card_payment_page.dart](lib/presentation/payment/pages/card_payment_page.dart) passa a navegar para esse estado em vez de assumir sucesso imediato.
9. Fase 4, integração de challenge: se a documentação permitir challenge embarcado, adicionar a dependência oficial de WebView em [pubspec.yaml](pubspec.yaml) e hospedar o desafio numa tela dedicada. Se a documentação proibir WebView ou exigir SDK, implementar bridge Flutter-plataforma com entrada em [android/app/src/main/kotlin/br/com/simohuapp/MainActivity.kt](android/app/src/main/kotlin/br/com/simohuapp/MainActivity.kt) e [ios/Runner/AppDelegate.swift](ios/Runner/AppDelegate.swift).
10. Fase 4, callback e retomada: registrar retorno Android e iOS em [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) e [ios/Runner/Info.plist](ios/Runner/Info.plist). O ideal é persistir localmente orderId, transactionId, status local e timestamp para retomar autenticação interrompida após background ou kill.
11. Fase 4, rollout controlado: estender [lib/common/services/payment_remote_config_service.dart](lib/common/services/payment_remote_config_service.dart) com flags de 3DS por crédito, débito e estratégia escolhida. Isso permite ativação gradual sem acoplar tudo a release de app.
12. Fase 5, UX e segurança operacional: tratar submit duplicado, cancelamento, timeout, retorno inválido, transação já finalizada e expiração de token durante autenticação. O carrinho só pode ser limpo depois da confirmação final do backend.
13. Fase 5, homologação: validar Android e iOS com cartões sandbox em cenários frictionless, challenge aprovado, challenge negado, cancelado, timeout, offline antes do submit, retorno por callback e retomada após background.

**Arquivos Relevantes**
- [lib/data/data/payment/payment_data_source.dart](lib/data/data/payment/payment_data_source.dart) — ponto certo para resposta 3DS mais rica e para desligar enqueue offline no pagamento interativo.
- [lib/domain/usecases/payment/payment_usecase.dart](lib/domain/usecases/payment/payment_usecase.dart) — converte dados para entidades e deve absorver o novo contrato ou delegar para um use case específico.
- [lib/presentation/payment/state/card_payment_notifier.dart](lib/presentation/payment/state/card_payment_notifier.dart) — hoje assume autorização imediata; será o orquestrador do state machine.
- [lib/presentation/payment/state/card_payment_state.dart](lib/presentation/payment/state/card_payment_state.dart) — precisa representar pending3ds, challenge, verifying e retomada.
- [lib/presentation/payment/pages/card_payment_page.dart](lib/presentation/payment/pages/card_payment_page.dart) — entrada da jornada do usuário para cartão.
- [lib/common/routing/router_config.dart](lib/common/routing/router_config.dart) — registro da nova rota de challenge.
- [lib/common/routing/route_names.dart](lib/common/routing/route_names.dart) — inclusão dos identificadores de rota.
- [lib/common/api_config/api_routes.dart](lib/common/api_config/api_routes.dart) — novos endpoints ou enriquecimento do contrato atual.
- [lib/common/services/payment_remote_config_service.dart](lib/common/services/payment_remote_config_service.dart) — rollout gradual.
- [lib/common/api_config/api_request_queue.dart](lib/common/api_config/api_request_queue.dart) — referência do comportamento atual que não serve para 3DS.
- [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) — callback Android e requisitos do gateway/SDK.
- [android/app/src/main/kotlin/br/com/simohuapp/MainActivity.kt](android/app/src/main/kotlin/br/com/simohuapp/MainActivity.kt) — bridge nativo Android.
- [ios/Runner/Info.plist](ios/Runner/Info.plist) — URL scheme ou associated domains.
- [ios/Runner/AppDelegate.swift](ios/Runner/AppDelegate.swift) — bridge nativo iOS e retorno do challenge.
- [pubspec.yaml](pubspec.yaml) — entrada de dependências condicionais, principalmente WebView se essa trilha for aprovada.

**Verificação E Decisões**
1. Validar com o backend um contrato que exponha claramente pending3ds, callback e confirmação final.
2. Testar as transições do notificador para sucesso, falha, cancelamento, timeout e retorno tardio.
3. Homologar Android e iOS com cenários frictionless e challenge completo.
4. Garantir que nenhuma requisição interativa de 3DS entre na fila offline.
5. Garantir que a limpeza de carrinho e os invalidates só ocorram após confirmação final do backend.

Decisões já assumidas no plano:
- O app fala apenas com o backend atual.
- Android e iOS entram na primeira entrega.
- WebView é a trilha preferida se a documentação oficial permitir.
- Se a documentação não permitir WebView, o plano já prevê migração para bridge nativa sem refazer a arquitetura.
- A bandeira do cartão não deve dirigir a lógica do cliente além da elegibilidade retornada pelo backend; o que realmente governa o app é o contrato do gateway.

Se você quiser, o próximo refinamento útil é um destes:
1. Me enviar a documentação do gateway para eu fechar o plano em uma única trilha, WebView ou nativa.
2. Pedir que eu transforme esse plano em backlog técnico, já quebrado por mobile, backend e QA.