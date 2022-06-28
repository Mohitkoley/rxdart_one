import 'dart:async';
import "package:rxdart/rxdart.dart";
import 'package:flutter/material.dart';
import 'package:rxdart_one/demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final BehaviorSubject<List<String>> streamController =
      BehaviorSubject<List<String>>();

  StreamTransformer<List<String>, List<String>> get streamTransformer =>
      StreamTransformer<List<String>, List<String>>.fromHandlers(
          handleData: (data, sink) {
        sink.add(data
            .map(
              (e) => e.toUpperCase(),
            )
            .toList());
      });

  @override
  void initState() {
    fetchData();
    _learnStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: "Enter Something", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 400,
              child: StreamBuilder(
                  stream: streamController.transform(streamTransformer),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      List<String> data = snapshot.data as List<String>;
                      return ListView(
                          children: data
                              .map(
                                (e) => ListTile(title: Text(e)),
                              )
                              .toList());
                    }
                    return Text(snapshot.error.toString());
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          fetchData();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  Future _learnStream() async {
    //var subject = StreamController<String>.broadcast();
    //var subject = publishSubject(); this listen to data that is xadded after the stream is created.
    //var subject = BehaviorSubject(); this does like above but also listen to last data added before subscribing
    var subject = ReplaySubject<
        String>(); // this listen all data added before subscribing

    // subject

    //     //.map((event) => event.substring(event.length - 1))
    //     //.map((event) => num.tryParse(event))
    //     .debounceTime(const Duration(seconds: 1))
    //     .asyncMap((event) async => await fetchWelcomeString())
    //     .map((event) => event.isNotEmpty ? event : "")
    //     .listen((event) {
    //   debugPrint("Added $event to sub1");
    // });

    // subject.add("Hello 1");

    // subject.add("hello 2");

    // RangeStream(6, 1)
    //     .flatMap((value) => TimerStream(value, Duration(seconds: value)))
    //     .listen((event) {
    //   //this will emit 5,4,3,2,1
    //   debugPrint("Added $event to sub1 ");
    // });

    fetchHelloString()
        .asStream()
        .mergeWith([fetchWelcomeString().asStream()]).listen((event) {
      debugPrint("Added $event to sub1");
    });

    subject.listen((event) {
      debugPrint("Added $event to sub 2");
    });

    subject.add("hello 3");
  }

  Future fetchData() async {
    final stopwatch = Stopwatch();
    stopwatch.start();
    streamController.sink.add(helloString);
    debugPrint("executed in ${stopwatch.elapsedMilliseconds}ms");
    stopwatch.stop();
  }
}
