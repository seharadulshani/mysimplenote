import 'package:MySimpleNote/service/noteService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/Note.dart';

class ViewNote extends StatefulWidget {
  final Note note;
  const ViewNote({super.key, required this.note});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteService = NoteServices();
  late bool _validateNote = false;
  bool _hasChanges = false;

  late String _initialTitle;
  late String _initialContent;

  @override
  void initState() {
    super.initState();

    _initialTitle = widget.note.header ?? '';
    _initialContent = widget.note.details ?? '';
    _titleController.text = _initialTitle;
    _contentController.text = _initialContent;

    _titleController.addListener(_onNoteChanged);
    _contentController.addListener(_onNoteChanged);
  }

  void _onNoteChanged() {
    setState(() {
      _hasChanges = _titleController.text != _initialTitle ||
          _contentController.text != _initialContent;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Icons.notes),
                ),

                Row(
                  children: [
                    if (_hasChanges)
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _titleController.text.isEmpty
                                ? _validateNote = true
                                : _validateNote = false;
                          });
                          if (!_validateNote) {
                            var note = Note();
                            note.note_id = widget.note.note_id;
                            note.created_at = widget.note.created_at;
                            note.header = _titleController.text;
                            note.details = _contentController.text;
                            var result = await _noteService.updateNote(note);
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 25,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'header',
                errorText: _validateNote ? 'Value can\'t be empty' : null,
              ),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1,
                fontFamily: 'SF Pro',
              ),
            ),
            TextField(
              controller: _contentController,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'details',
                errorText: _validateNote ? 'Value can\'t be empty' : null,
              ),
              style: const TextStyle(
                fontSize: 16,
                height: 1,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
