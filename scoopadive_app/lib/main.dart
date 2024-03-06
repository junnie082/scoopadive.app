import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoopadive_app/screens/divepedia.dart';
import 'package:scoopadive_app/screens/happybuddies.dart';
import 'package:scoopadive_app/screens/home.dart';
import 'package:scoopadive_app/screens/logs.dart';
import 'package:scoopadive_app/utils/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

String model = "text-davinci-002";
const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/engines/text-davinci-003/completions';

void main() {
  String prompt = "Ask something";
  Future<String> data = generateText(prompt);
  data.then((value) {
    print("value: $value");
  }).catchError((error) {
    print("Error occurred: $error");
  });
  runApp(const MyApp());
}

Future<String> generateText(String prompt) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode(
          {'prompt': prompt, 'max_tokens': 100, 'n': 1, 'stop': '.'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['choices'][0]['text'];
    } else {
      throw Exception('Failed to generate text: ${response.statusCode}');
    }
  } catch (e) {
    // Handle errors
    print('Error generating text: $e');
    return ''; // Return empty string or any default value
  } // Return empty string or any default value
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scoop A Dive App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueLight,
        foregroundColor: blueDark,
        elevation: 0,
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: [
          const Home(),
          const Logs(),
          const HappyBuddies(),
          const Divepedia(),
        ][currentPageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: blue,
          selectedItemColor: blueLight,
          showUnselectedLabels: true,
          currentIndex: currentPageIndex,
          onTap: (int index) {
            setState(() {
              print(index);
              currentPageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('icons/home.svg', color: blueDark),
              activeIcon: SvgPicture.asset('icons/home.svg', color: blueDark),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('icons/book.svg', color: blueDark),
              activeIcon: SvgPicture.asset('icons/book.svg', color: blueDark),
              label: 'Logs',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('icons/challenge.svg', color: blueDark),
              activeIcon:
                  SvgPicture.asset('icons/challenge.svg', color: blueDark),
              label: 'Happy Buddies',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('icons/profile.svg', color: blueDark),
              activeIcon:
                  SvgPicture.asset('icons/profile.svg', color: blueDark),
              label: 'Divepedia',
            ),
          ]),
    );
  }
}
