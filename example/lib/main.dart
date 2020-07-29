import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        // baseColor: Color(0xFFFFFFFF),
        intensity: 0.85,
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      title: 'Numpad Example',
      // theme: ThemeData(primarySwatch: Colors.blue),
      home: FormattedNumpadExample(),
    );
  }
}

class FormattedNumpadExample extends StatelessWidget {
  final NumpadController _numpadController =
      NumpadController(format: NumpadFormat.PIN6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Numpad Example'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NumpadText(
                isObscureText: false,
                style: TextStyle(fontSize: 40),
                controller: _numpadController,
              ),
            ),
            Expanded(
              child: Numpad(
                controller: _numpadController,
                buttonTextSize: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
