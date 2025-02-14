import 'integrations/supabase.dart';
import 'screens/chapters_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memochat/data/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memochat/screens/chapter_screen.dart';

Future<void> main() async {
  await SupabaseService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'MemoChat AI',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.outfitTextTheme(),
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF38855D), // Brand green
            onPrimary: const Color(0xFFFFFFFF), // White
            secondary: const Color(0xFFFFD379), // Brand yellow/gold
            tertiary: const Color(0xFF994058), // Brand burgundy
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Color _getChapterIconColor(BuildContext context, Chapter chapter) {
  int chapterIndex = chaptersList.indexOf(chapter);
  return chapterIndex < chaptersList.length / 3
      ? Theme.of(context).colorScheme.primary
      : chapterIndex < 2 * chaptersList.length / 3
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.tertiary;
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Widget extendedScreen;
      switch (selectedIndex) {
        case 0:
          extendedScreen = ChaptersScreen(
            onChapterSelected: (chapterIndex) {
              setState(() {
                selectedIndex = chapterIndex;
              });
            },
          );
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
          extendedScreen = ChatScreen(chapter: chaptersList[selectedIndex - 1]);
        default:
          throw UnimplementedError('no widget for $selectedIndex');
      }

      return Scaffold(
        body: Row(children: [
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey[200]!, // Dark border color
                    width: 1.0, // Border width
                  ),
                ),
              ),
              child: NavigationRail(
                extended: constraints.maxWidth >= widthForMobile,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  for (var chapter in chaptersList) ...[
                    NavigationRailDestination(
                      icon: Icon(chapter.iconData,
                          color: _getChapterIconColor(context, chapter)),
                      label: Text(chapter.name),
                    ),
                  ],
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: extendedScreen,
            ),
          ),
        ]),
      );
    });
  }
}

class TBDScreen extends StatelessWidget {
  final String titlePassedByParam;

  TBDScreen({required this.titlePassedByParam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titlePassedByParam),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(60, (index) => Text('TBD Screen')),
        ),
      ),
    );
  }
}
