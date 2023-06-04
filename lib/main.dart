import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:flutter_midi/flutter_midi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedMenu = "expressive";

  @override
  void initState() {
    load('assets/$selectedMenu.sf2');
    super.initState();
  }

  void load(String asset) async {
    FlutterMidi().unmute();
    // ignore: no_leading_underscores_for_local_identifiers
    ByteData _byte = await rootBundle.load(asset);
    FlutterMidi().prepare(
        sf2: _byte, name: "assets/$selectedMenu.sf2".replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Piano Demo'),
            actions: [
              DropdownButton(
                  value: selectedMenu ?? "expressive",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 90, 89, 89), fontSize: 16),
                  iconEnabledColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: "expressive",
                      child: Text('expressive'),
                    ),
                    DropdownMenuItem(
                      value: "guitars",
                      child: Text('guitars'),
                    ),
                    DropdownMenuItem(
                      value: "yamaha-Grand",
                      child: Text('Piano'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedMenu = value;
                    });
                    load("assets/$value.sf2");
                  })
            ],
          ),
          body: Center(
            child: InteractivePiano(
              highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
              naturalColor: Colors.white,
              accidentalColor: Colors.black,
              keyWidth: 60,
              noteRange: NoteRange.forClefs([
                Clef.Treble,
              ]),
              onNotePositionTapped: (position) {
                FlutterMidi().playMidiNote(midi: position.pitch);
                FlutterMidi().stopMidiNote(midi: 60);
              },
            ),
          ),
        ));
  }
}
