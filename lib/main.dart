import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Brightness brightness;
  defalutBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    brightness =
        (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    defalutBrightness();
    return DynamicTheme(
        defaultBrightness: brightness,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Easy Theme"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Color will change follow theme",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              child: Text("Color will notchange follow theme",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            RaisedButton(
              onPressed: changeBrightness,
              child: const Text("Change brightness"),
            ),
            RaisedButton(
              onPressed: changeColor,
              child: const Text("Change color"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showChooser,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).buttonColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Text("Tab 1"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), title: Text("Tab 2")),
        ],
      ),
    );
  }

  void showChooser() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return BrightnessSwitcherDialog(
            onSelectedTheme: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
          );
        });
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  void changeColor() {
    DynamicTheme.of(context).setThemeData(ThemeData(
        primaryColor: Theme.of(context).primaryColor == Colors.indigo
            ? Colors.red
            : Colors.indigo));
  }
}
