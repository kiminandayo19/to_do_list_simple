import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Simple To Do List App",
          themeMode: themeProvider.themeMode,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          home: const MainApp(),
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<String> list = <String>[];

  final _addItemsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 80,
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "What To Do Today?",
                  style: GoogleFonts.signikaNegative(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const ChangeThemeButtonWidget(),
              ],
            ),
            list.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Text(
                        "You Have Nothing To Do Today",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.signikaNegative(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, index) {
                        return Text(
                          "${index + 1}. ${list[index]}",
                          style: GoogleFonts.signikaNegative(
                            fontSize: 14,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, index) =>
                          const SizedBox(
                        height: 20,
                      ),
                    ),
                  ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        list.clear();
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          "Add To Do Items",
                          style: GoogleFonts.signikaNegative(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: TextFormField(
                          controller: _addItemsController,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, "Cancel"),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.signikaNegative(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              handleAddItem(_addItemsController.text);
                              // Navigator.pop(context);
                            },
                            // onPressed: () => Navigator.pop(context, "Add Item"),
                            child: Text(
                              "Add Item",
                              style: GoogleFonts.signikaNegative(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    elevation: 4,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleAddItem(String value) {
    setState(() {
      list.add(value);
    });
    _addItemsController.clear();
  }
}

// ThemesData
class Themes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3F3351),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 47, 30, 118),
    ),
    dividerColor: Colors.black,
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1F1D36),
    colorScheme: const ColorScheme.dark(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0XFF3D2C8D),
    ),
    dividerColor: Colors.white,
  );
}

// ThemeProvider
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// ChangeThemeButtonWidget
class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider? themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoSwitch(
      trackColor: const Color(0xFF3D2C8D),
      activeColor: const Color.fromARGB(255, 68, 64, 71),
      thumbColor: const Color(0xFFFFFFFF),
      value: themeProvider.isLight,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
