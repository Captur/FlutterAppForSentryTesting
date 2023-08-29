import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const launchChannel = MethodChannel("event/launchChannel");
  String batteryLevel = "Waiting";

  static Future<void> listenToCallbacks() async {
    launchChannel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'capturCallback') {
      // Handle the callback from native iOS app
      print('Received callback from native: ${call.arguments}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                batteryLevel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: launchCaptur,
                child: const Text("Launch Captur"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future launchCaptur() async {
    listenToCallbacks();
    await launchChannel.invokeMethod('launchCaptur');
  }
}
