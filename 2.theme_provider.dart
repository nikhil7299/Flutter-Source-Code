import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String themeMode = prefs.getString('themeMode') ?? 'dark';
  final int seedColorValue =
      prefs.getInt('seedColorValue') ?? Colors.blue.value;
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(
        themeMode: themeMode.mode,
        seedColor: Color(seedColorValue),
      ),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.seedColor,
          brightness: Brightness.dark,
          background: Colors.black87,
        ),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.black12,
        ),
      ),
      home: const AThemeDemo(),
    );
  }
}

class AThemeDemo extends StatelessWidget {
  const AThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Theme FlutterFury",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: const TabBarView(
          children: [
            AHome(),
            ASettings(),
          ],
        ),
        bottomNavigationBar: TabBar(
          splashBorderRadius: BorderRadius.circular(60),
          splashFactory: NoSplash.splashFactory,
          indicatorPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          labelColor: Theme.of(context).colorScheme.onPrimary,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(60),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.only(bottom: 20, top: 5),
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.house_alt),
                  SizedBox(width: 15),
                  Text(
                    "Home",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.settings),
                  SizedBox(width: 15),
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AHome extends StatelessWidget {
  const AHome({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customCardList = [
      CustomCard(cardColor: colorScheme.primary, colorName: 'Primary'),
      CustomCard(
        cardColor: colorScheme.onPrimary,
        colorName: 'On Primary',
        textColor: colorScheme.onSurface,
      ),
      CustomCard(
        cardColor: colorScheme.primaryContainer,
        colorName: 'Primary Container',
        textColor: colorScheme.onSurface,
      ),
      CustomCard(
          cardColor: colorScheme.onPrimaryContainer,
          colorName: 'On Primary Container'),
      CustomCard(cardColor: colorScheme.secondary, colorName: 'Secondary'),
      CustomCard(
        cardColor: colorScheme.onSecondary,
        colorName: 'On Secondary',
        textColor: colorScheme.onSurface,
      ),
      CustomCard(
          cardColor: colorScheme.secondaryContainer,
          textColor: colorScheme.onSurface,
          colorName: 'Secondary Container'),
      CustomCard(
        cardColor: colorScheme.onSecondaryContainer,
        colorName: 'On Secondary Container',
      ),
      CustomCard(
        cardColor: colorScheme.surface,
        colorName: 'Surface',
        textColor: colorScheme.onSurface,
      ),
      CustomCard(cardColor: colorScheme.onSurface, colorName: 'On Surface'),
      CustomCard(
        cardColor: colorScheme.surfaceVariant,
        colorName: 'Surface Variant',
        textColor: colorScheme.onSurface,
      ),
      CustomCard(
          cardColor: colorScheme.onSurfaceVariant,
          colorName: 'On Surface Variant'),
      CustomCard(cardColor: colorScheme.outline, colorName: 'Outline'),
      CustomCard(
          cardColor: colorScheme.outlineVariant, colorName: 'Outline Variant'),
    ];
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      children: customCardList,
    );
  }
}

class CustomCard extends StatelessWidget {
  final Color cardColor;
  final String colorName;
  final Color? textColor;
  const CustomCard({
    super.key,
    required this.cardColor,
    required this.colorName,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: SizedBox(
        height: 44,
        child: Center(
          child: Text(
            'Color : $colorName',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}

class AppThemeMode {
  ThemeMode themeMode;
  String title;

  AppThemeMode({
    required this.themeMode,
    required this.title,
  });
}

extension ThemeModeExtension on String {
  ThemeMode get mode => switch (this) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

class ASettings extends StatelessWidget {
  const ASettings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AppThemeMode> appThemeModes = [
      AppThemeMode(themeMode: ThemeMode.light, title: 'Light'),
      AppThemeMode(themeMode: ThemeMode.dark, title: 'Dark'),
      AppThemeMode(themeMode: ThemeMode.system, title: 'System'),
    ];
    final seedColors = [
      Colors.blue,
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.red,
      Colors.pink,
      Colors.deepPurple,
      Colors.deepOrange,
    ];
    final theme = Provider.of<ThemeNotifier>(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
        child: Container(
          height: size.height * 0.45,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.4,
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Text(
                "Theme Settings",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: appThemeModes
                    .map(
                      (appThemeMode) => InkWell(
                        onTap: () {
                          theme.setThemeMode(themeMode: appThemeMode.themeMode);
                        },
                        splashFactory: NoSplash.splashFactory,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/${appThemeMode.title.toLowerCase()}.jpg',
                                fit: BoxFit.cover,
                                height: 90,
                                width: 90,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(appThemeMode.title),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              GridView.builder(
                shrinkWrap: true,
                itemCount: seedColors.length,
                padding: const EdgeInsets.all(20),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: size.height * 0.02,
                  crossAxisSpacing: size.width * 0.1,
                ),
                itemBuilder: (context, index) {
                  final seedColor = seedColors.elementAt(index);
                  return IconButton(
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: seedColor,
                    ),
                    onPressed: () => theme.setSeedColor(seedColor: seedColor),
                    icon: Icon(
                      theme.seedColor.value == seedColor.value
                          ? Icons.check_circle_outline_rounded
                          : null,
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// Theme Notifier
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _seedColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  ThemeNotifier({required ThemeMode themeMode, required Color seedColor}) {
    _themeMode = themeMode;
    _seedColor = seedColor;
  }

  void setThemeMode({required ThemeMode themeMode}) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = themeMode;
    prefs.setString('themeMode', _themeMode.name);
    notifyListeners();
  }

  void setSeedColor({required Color seedColor}) async {
    final prefs = await SharedPreferences.getInstance();
    _seedColor = seedColor;
    prefs.setInt('seedColorValue', _seedColor.value);
    notifyListeners();
  }
}
