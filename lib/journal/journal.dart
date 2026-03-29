import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/app_state.dart';
import '/util/network.dart';
import '/util/global.dart';

class JournalApp extends StatefulWidget {
  @override
  JournalPageState createState() => JournalPageState();
}

class JournalEntry {
  final String id;
  final String content;
  final DateTime date;

  JournalEntry(this.id, this.content, this.date);
}

class JournalPageState extends State<JournalApp> {
  final TextEditingController textCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();

  String searchQuery = '';

  List<JournalEntry> journalList = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  @override
  void dispose() {
    textCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> loadEntries() async {
    try {
      final appState = context.read<AppState>();

      final data = await httpDataSecure<List<dynamic>, List<dynamic>>(
        HttpRequestType.post,
        API.journalEntries,
        includeToken(
          appState.session.getEmail()!,
          appState.session.getToken()!,
          {"method_override": "GET"},
        ),
        (json) => json,
        (status) => [],
      );

      setState(() {
        journalList = data.map<JournalEntry>((e) {
          final id = (e['id'] ?? '').toString();
          final content = (e['content'] ?? '').toString();
          final parsed = DateTime.parse(e['date'].toString());
          return JournalEntry(id, content, parsed);
        }).toList();
      });
    } catch (e) {
      print("Error loading entries: $e");
    }
  }

  Future<void> addEntry() async {
    final entryText = textCtrl.text.trim();
    if (entryText.isEmpty) return;

    try {
      final appState = context.read<AppState>();

      await httpPostSecure(
        API.journalEntries,
        includeToken(
          appState.session.getEmail()!,
          appState.session.getToken()!,
          {"content": entryText},
        ),
        (_) {},
        (_) {},
      );

      textCtrl.clear();
      await loadEntries();
    } catch (e) {
      print("Error adding entry: $e");
    }
  }

  Future<void> editEntry(JournalEntry entry) async {
    final TextEditingController editCtrl =
        TextEditingController(text: entry.content);

    final updatedText = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Entry',
            style: GoogleFonts.caveat(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          content: TextField(
            controller: editCtrl,
            maxLines: 6,
            style: GoogleFonts.caveat(
              fontSize: 20,
              color: Colors.brown.shade800,
            ),
            decoration: InputDecoration(
              hintText: 'Update your entry...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.caveat(fontSize: 22),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, editCtrl.text.trim()),
              child: Text(
                'Save',
                style: GoogleFonts.caveat(fontSize: 22),
              ),
            ),
          ],
        );
      },
    );

    if (updatedText == null || updatedText.isEmpty || updatedText == entry.content) {
      return;
    }

    try {
      final appState = context.read<AppState>();

      await httpDataSecure<Map<String, dynamic>, Map<String, dynamic>>(
        HttpRequestType.post,
        '${API.journalEntries}${entry.id}/',
        includeToken(
          appState.session.getEmail()!,
          appState.session.getToken()!,
          {
            "method_override": "PUT",
            "content": updatedText,
          },
        ),
        (json) => json,
        (status) => {},
      );

      await loadEntries();
    } catch (e) {
      print("Error editing entry: $e");
    }
  }

  bool matchesDateSearch(JournalEntry entry, String q) {
    final localDate = entry.date.toLocal();

    final formats = [
      DateFormat('MMMM d, y'),
      DateFormat('MMM d, y'),
      DateFormat('M/d/y'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('MMMM d'),
      DateFormat('MMM d'),
      DateFormat('MMMM'),
      DateFormat('MMM'),
      DateFormat('yyyy'),
    ];

    for (final format in formats) {
      if (format.format(localDate).toLowerCase().contains(q)) {
        return true;
      }
    }

    return false;
  }

  List<JournalEntry> get filteredEntries {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return journalList;

    return journalList.where((e) {
      final contentMatch = e.content.toLowerCase().contains(q);
      final dateMatch = matchesDateSearch(e, q);
      return contentMatch || dateMatch;
    }).toList();
  }

  Map<String, List<JournalEntry>> groupByDate(List<JournalEntry> entries) {
    final Map<String, List<JournalEntry>> grouped = {};

    for (var entry in entries) {
      final localDate = entry.date.toLocal();
      final dateKey = DateFormat('MMMM d, y').format(localDate);
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => DateFormat('MMMM d, y')
          .parse(b)
          .compareTo(DateFormat('MMMM d, y').parse(a)));

    for (final key in grouped.keys) {
      grouped[key]!.sort((x, y) => y.date.compareTo(x.date));
    }

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  String formatTime(DateTime date) =>
      DateFormat('h:mm a').format(date.toLocal());

  Widget highlightedText(String text, String query) {
    final q = query.trim();
    if (q.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.caveat(fontSize: 20, color: Colors.brown.shade800),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQ = q.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQ, start);
      if (index < 0) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: GoogleFonts.caveat(
            fontSize: 20,
            color: Colors.brown.shade800,
          ),
        ));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: GoogleFonts.caveat(
            fontSize: 20,
            color: Colors.brown.shade800,
          ),
        ));
      }

      final matchEnd = index + q.length;
      spans.add(TextSpan(
        text: text.substring(index, matchEnd),
        style: GoogleFonts.caveat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.yellow.shade200,
          color: Colors.brown.shade900,
        ),
      ));

      start = matchEnd;
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final groupedEntries = groupByDate(filteredEntries);
    final bool noResults = filteredEntries.isEmpty;
    final bool isSearching = searchQuery.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Journal',
          style: GoogleFonts.caveat(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        color: Colors.green.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: GoogleFonts.caveat(
                fontSize: 20,
                color: Colors.brown.shade800,
              ),
              decoration: InputDecoration(
                hintText: 'Search entries...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.trim().isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchCtrl.clear();
                            searchQuery = '';
                          });
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textCtrl,
              maxLines: 4,
              style: GoogleFonts.caveat(
                fontSize: 20,
                color: Colors.brown.shade800,
              ),
              decoration: InputDecoration(
                hintText: 'Write your thoughts...',
                filled: true,
                fillColor: Colors.brown.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Save Entry',
                style: GoogleFonts.caveat(fontSize: 22),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: (journalList.isEmpty && !isSearching)
                  ? Center(
                      child: Text(
                        'No entries yet.',
                        style: GoogleFonts.caveat(
                          fontSize: 22,
                          color: Colors.green.shade900,
                        ),
                      ),
                    )
                  : (noResults && isSearching)
                      ? Center(
                          child: Text(
                            'No results found.',
                            style: GoogleFonts.caveat(
                              fontSize: 22,
                              color: Colors.green.shade900,
                            ),
                          ),
                        )
                      : ListView(
                          children: groupedEntries.entries.map((group) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ExpansionTile(
                                title: Text(
                                  group.key,
                                  style: GoogleFonts.caveat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                children: group.value.map((entry) {
                                  return ListTile(
                                    title: highlightedText(
                                      entry.content,
                                      searchQuery,
                                    ),
                                    subtitle: Text(
                                      formatTime(entry.date),
                                      style: GoogleFonts.caveat(
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => editEntry(entry),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}