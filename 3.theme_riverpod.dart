import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: const [StateLogger()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ThemeRiverpodApp(),
    ),
  );
}

class ThemeModeColor {
  final ThemeMode themeMode;
  final Color seedColor;

  ThemeModeColor({required this.themeMode, required this.seedColor});

  ThemeModeColor copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
  }) {
    return ThemeModeColor(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  String toString() =>
      'ThemeModeColor (themeMode: $themeMode, seedColor: $seedColor)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeModeColor &&
        other.themeMode == themeMode &&
        other.seedColor == seedColor;
  }

  @override
  int get hashCode => themeMode.hashCode ^ seedColor.hashCode;
}

extension ThemeModeExtension on String {
  ThemeMode get mode => switch (this) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeModeColor>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeModeColor> {
  @override
  ThemeModeColor build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    final String themeMode = prefs.getString('themeMode') ?? 'dark';
    final int seedColorValue =
        prefs.getInt('seedColorValue') ?? Colors.blue.value;

    return ThemeModeColor(
      themeMode: themeMode.mode,
      seedColor: Color(seedColorValue),
    );
  }

  void setThemeMode({required ThemeMode themeMode}) {
    ref.read(sharedPreferencesProvider).setString('themeMode', themeMode.name);
    state = state.copyWith(themeMode: themeMode);
  }

  void setSeedColor({required Color seedColor}) async {
    ref
        .read(sharedPreferencesProvider)
        .setInt('seedColorValue', seedColor.value);
    state = state.copyWith(seedColor: seedColor);
  }
}

class ThemeRiverpodApp extends ConsumerStatefulWidget {
  const ThemeRiverpodApp({super.key});

  @override
  ConsumerState<ThemeRiverpodApp> createState() => _ThemeRiverpodAppState();
}

class _ThemeRiverpodAppState extends ConsumerState<ThemeRiverpodApp> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Accessing Theme Provider
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.seedColor,
          brightness: Brightness.light,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: size.height * 0.075,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.seedColor,
          brightness: Brightness.dark,
          background: Colors.black,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: size.height * 0.075,
        ),
      ),
      home: const ThemeRiverpodDemo(),
    );
  }
}

class ThemeRiverpodDemo extends ConsumerStatefulWidget {
  const ThemeRiverpodDemo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ThemeRiverpodDemoState();
}

class _ThemeRiverpodDemoState extends ConsumerState<ThemeRiverpodDemo> {
  int selectedIndex = 0;

  final destinationViews = [
    const BHome(),
    const BSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Theme Riverpod - FlutterFury",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: destinationViews[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              CupertinoIcons.house_alt,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              CupertinoIcons.settings,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: "Settings",
          ),
        ],
      ),
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

class BHome extends StatelessWidget {
  const BHome({super.key});

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

class AppThemeMode {
  ThemeMode themeMode;
  String title;

  AppThemeMode({
    required this.themeMode,
    required this.title,
  });
}

class BSettings extends ConsumerWidget {
  const BSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          ref
                              .read(themeProvider.notifier)
                              .setThemeMode(themeMode: appThemeMode.themeMode);
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
                    onPressed: () => ref
                        .read(themeProvider.notifier)
                        .setSeedColor(seedColor: seedColor),
                    icon: Icon(
                      ref.read(themeProvider).seedColor.value == seedColor.value
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
