import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MySimpleNote/model/Note.dart';
import 'package:MySimpleNote/screens/addNewNote.dart';
import 'package:MySimpleNote/screens/viewNote.dart';
import 'package:MySimpleNote/service/noteService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Simple Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.teal,
          secondary: Colors.blueAccent,
          surface: Colors.white,
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          displayLarge:
              const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(color: Colors.black87),
          bodyMedium: const TextStyle(color: Colors.grey),
          bodySmall: TextStyle(color: Colors.grey[600]),
          labelLarge:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.teal,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Note> _noteList = [];
  late List<Note> _filteredNoteList = [];
  final _noteService = NoteServices();
  final TextEditingController _searchController = TextEditingController();

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  getAllNotes() async {
    var notes = await _noteService.readAllNotes();
    _noteList = <Note>[];
    notes.forEach((notesData) {
      var notesModel = Note();
      notesModel.note_id = notesData['note_id'];
      notesModel.header = notesData['header'];
      notesModel.details = notesData['details'];
      notesModel.created_at = DateTime.tryParse(notesData['created_at'] ?? '');
      _noteList.add(notesModel);
    });

    _filterNotes();
  }

  void _filterNotes() {
    setState(() {
      _filteredNoteList = _noteList.where((note) {
        return note.header!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDummyData();
    getAllNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'My, Simple Notes',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Notes',
                    prefixIcon: Icon(Icons.search, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.teal, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _filteredNoteList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, bottom: 0, right: 20, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewNote(note: _filteredNoteList[index]),
                        ),
                      ).then((data) {
                        if (data != null) {
                          getAllNotes();
                          _showSuccessSnackBar('Note Updated Successfully');
                        }
                      });
                    },
                    child: Card(
                      color: Colors.grey[80],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _filteredNoteList[index].created_at != null
                                      ? DateFormat('d MMM').format(
                                          _filteredNoteList[index].created_at!)
                                      : 'No Date',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _filteredNoteList[index].header ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _filteredNoteList[index].details ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.2,
                              ),
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _deleteNoteDialog(context,
                                        _filteredNoteList[index].note_id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewNote()),
          ).then((data) {
            if (data != null) {
              getAllNotes();
              _showSuccessSnackBar('Note Added Successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: const BottomAppBar(
        color: Colors.white,
        elevation: 5,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }

  _deleteNoteDialog(BuildContext context, noteId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Are You Sure to delete',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () async {
                var result = await _noteService.deleteNote(noteId);
                Navigator.pop(context);
                if (result != null) {
                  getAllNotes();
                  _showSuccessSnackBar('Note Deleted Successfully');
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightGreenAccent),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initializeDummyData() async {
    var notes = await _noteService.readAllNotes();

    if (notes.isEmpty) {
      List<Note> dummyNotes = [
        Note(
          header: "Grocery List",
          details: "Milk, Eggs, Bread, Apples, Bananas, Chicken",
          created_at: DateTime.now().subtract(Duration(days: 1)),
        ),
        Note(
          header: "Project Ideas",
          details: "1. Weather app, 2. Todo list, 3. Recipe book app",
          created_at: DateTime.now().subtract(Duration(days: 2)),
        ),
        Note(
          header: "Travel Checklist",
          details: "Passport, Tickets, Hotel Booking, Charger, Sunscreen",
          created_at: DateTime.now().subtract(Duration(days: 3)),
        ),
        Note(
          header: "Meeting Notes",
          details: "Discuss Q3 goals, budget updates, team expansion",
          created_at: DateTime.now().subtract(Duration(days: 4)),
        ),
        Note(
          header: "Recipe: Chocolate Cake",
          details: "Ingredients: Flour, Cocoa, Sugar, Eggs. Bake at 350°F",
          created_at: DateTime.now().subtract(Duration(days: 5)),
        ),
        Note(
          header: "Book Recommendations",
          details:
              "1. '1984' by George Orwell, 2. 'To Kill a Mockingbird' by Harper Lee",
          created_at: DateTime.now().subtract(Duration(days: 6)),
        ),
        Note(
          header: "Birthday Gift Ideas",
          details: "Watch, Headphones, Gift Card, Books",
          created_at: DateTime.now().subtract(Duration(days: 8)),
        ),
      ];

      for (var note in dummyNotes) {
        await _noteService.createNote(note);
      }
      getAllNotes();
    }
  }
}
