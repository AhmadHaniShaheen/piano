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
  String selectedMenu = "guitars";

  @override
  void initState() {
    load('assets/$selectedMenu.sf2');
    super.initState();
  }

  void load(String asset) async {
    FlutterMidi().unmute();
    // ignore: no_leading_underscores_for_local_identifiers
    ByteData _byte = await rootBundle.load(asset);
    FlutterMidi().prepare(sf2: _byte);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Piano Demo',
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Piano Demo'),
            actions: [
              PopupMenuButton<String>(
                initialValue: selectedMenu,
                // Callback that sets the selected popup menu item.
                onSelected: (String item) {
                  setState(() {
                    selectedMenu = item;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "guitars",
                    child: const Text('guitars'),
                    onTap: () {
                      setState(() {
                        selectedMenu = "guitars";
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: "expressive",
                    child: const Text('expressive'),
                    onTap: () {
                      setState(() {
                        selectedMenu = "expressive";
                      });
                    },
                  ),
                ],
              ),
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
                FlutterMidi().playMidiNote(midi: 50);
                FlutterMidi().stopMidiNote(midi: 60);
              },
            ),
          ),
        ));
  }
}
