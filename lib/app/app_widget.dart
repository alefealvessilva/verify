import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:verify/app/core/admob_store.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/core/app_store.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/core/remote_config_store.dart';
import 'package:verify/app/shared/extensions/app_scroll_behavior.dart';

import 'package:verify/app/shared/themes/theme.dart';
import 'package:verify/app/splash_screen_widget.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final appStore = Modular.get<AppStore>();
  final authStore = Modular.get<AuthStore>();
  final apiCredentialsStore = Modular.get<ApiCredentialsStore>();
  final adMobStore = Modular.get<AdMobStore>();
  final remoteConfigStore = Modular.get<RemoteConfigStore>();

  bool intialized = false;
  late final List<ReactionDisposer> _disposers;

  Future<void> loadData() async {
    try {
      Intl.defaultLocale = 'pt_BR';
      await initializeDateFormatting();
      await appStore.loadData();
      await authStore.loadData();
      await apiCredentialsStore.loadData();
      await remoteConfigStore.fetchConfig();
      remoteConfigStore.initRealtimeListeners();
      if (Platform.isAndroid || Platform.isIOS) {
        await adMobStore.initAdMob();
      }
    } catch (e) {
      debugPrint('Error during global initialization: $e');
    } finally {
      if (mounted) {
        Modular.setInitialRoute(appStore.idealRoute);

        setState(() {
          intialized = true;
        });

        _setupNavigation();
      }
    }
  }

  void _setupNavigation() {
    _disposers = [
      autorun((_) => _handleRedirection()),
    ];
  }

  void _handleRedirection() {
    debugPrint('AppWidget: _handleRedirection() triggered');
    if (!intialized) {
      debugPrint('AppWidget: _handleRedirection() aborted - not initialized');
      return;
    }

    final route = appStore.idealRoute;
    final currentRoute = Modular.to.path;

    // Remove barras finais para comparação uniforme
    final cleanRoute = _normalizeRoute(route);
    final cleanCurrent = _normalizeRoute(currentRoute);

    debugPrint('AppWidget: Redirection check -> Target: [$cleanRoute] | Current: [$cleanCurrent] | Raw: [$currentRoute]');

    if (cleanRoute != cleanCurrent) {
      debugPrint('AppWidget: Navigating to $cleanRoute...');
      // Usando SchedulerBinding para garantir que a navegação ocorra após o frame atual
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Modular.to.navigate(cleanRoute);
      });
    } else {
      debugPrint('AppWidget: No navigation needed. Already at $cleanRoute');
    }
  }

  String _normalizeRoute(String route) {
    if (route.length > 1 && route.endsWith('/')) {
      return route.substring(0, route.length - 1);
    }
    return route;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    for (final dispose in _disposers) {
      dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!intialized) return const SplashScreen();

    return Observer(
      builder: (context) {
        return MaterialApp.router(
          scrollBehavior: AppScrollBehavior(),
          debugShowCheckedModeBanner: false,
          themeMode: appStore.themeMode.value,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerDelegate: Modular.routerDelegate,
          routeInformationParser: Modular.routeInformationParser,
        );
      },
    );
  }
}
