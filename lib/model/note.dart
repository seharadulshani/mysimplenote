class Note {
  int? note_id;
  String? header;
  String? details;
  DateTime? created_at;

  noteMap() {
    var mapping = <String, dynamic>{};
    mapping['note_id'] = note_id ?? null;
    mapping['header'] = header!;
    mapping['details'] = details!;
    mapping['created_at'] = created_at?.toIso8601String();
    return mapping;
  }

  Note({
    this.note_id,
    this.header,
    this.details,
    this.created_at,
  });
}
