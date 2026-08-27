import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/theme.dart';
import 'app_state.dart';
import '../features/ai_chat/ai_chat_page.dart';
import '../features/home/home_page.dart';
import '../features/insights/insights_page.dart';
import '../features/journeys/journeys_page.dart';
import '../features/settings/settings_page.dart';
import '../services/ads/ads.dart';

class TryItApp extends StatelessWidget {
  const TryItApp({super.key, this.screenshotScene});

  final String? screenshotScene;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<AppState>().language;
    final isAr = language == AppLanguage.ar;
    return MaterialApp(
      title: AppStrings.appTagline,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: Locale(isAr ? 'ar' : 'en'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: child!,
      ),
      home: AppShell(screenshotScene: screenshotScene),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.screenshotScene});

  final String? screenshotScene;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = switch (widget.screenshotScene) {
      'journeys' => 1,
      'coach' => 2,
      'insights' => 3,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screenshotScene == 'challenge') {
      final paths = context.watch<AppState>().paths;
      return JourneyDetailPage(pathId: paths.first.id);
    }
    final pages = [
      HomePage(onOpenJourneys: () => setState(() => _selectedIndex = 1)),
      const JourneysPage(),
      const AiChatPage(),
      const InsightsPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: IndexedStack(index: _selectedIndex, children: pages)),
          if (!kIsWeb) const AdmobBannerWidget(margin: EdgeInsets.zero),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.route_outlined),
            selectedIcon: const Icon(Icons.route_rounded),
            label: AppStrings.journeys,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome_rounded),
            label: AppStrings.coach,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights_rounded),
            label: AppStrings.insights,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}
