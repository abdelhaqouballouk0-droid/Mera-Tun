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

class TryItApp extends StatelessWidget {
  const TryItApp({super.key, this.screenshotScene});

  final String? screenshotScene;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTagline,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
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
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route_rounded),
            label: AppStrings.journeys,
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            label: AppStrings.coach,
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: AppStrings.insights,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}
