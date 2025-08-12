import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'next_page.dart';
import 'uhf_result_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel(
    'com.example.tri_express/android_channel',
  );
  final _tagInfos = <UHFResultModel>[];

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'getTagInfo':
          final map = Map<String, dynamic>.from(call.arguments);
          final tagInfo = UHFResultModel.fromJson(map);
          final index = _tagInfos.indexWhere((e) => e.epcId == tagInfo.epcId);

          setState(() {
            index != -1
                ? _tagInfos[index].updateInfo(tagInfo: tagInfo)
                : _tagInfos.add(tagInfo);
          });

          break;
        case 'startInventory':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('${call.arguments}'),
            ),
          );
          break;
        case 'endInventory':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('${call.arguments}'),
            ),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemBuilder:
            (context, index) => ListTile(
              title: Text(_tagInfos[index].epcId),
              subtitle: Text('Frequency: ${_tagInfos[index].frequency}'),
              trailing: Text('RSSI: ${_tagInfos[index].rssi}'),
            ),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: _tagInfos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NextPage()),
            ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
