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
  final String content;
  final DateTime date;
  JournalEntry(this.content, this.date);
}

class JournalPageState extends State<JournalApp> {
  final TextEditingController textCtrl = TextEditingController();
  List<JournalEntry> journalList = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
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
          {"method_override": "GET"}
        ), 
        (json) => json, 
        (status) => []
      );

      setState(() {
        journalList = data.map<JournalEntry>((e) => JournalEntry(
          e['content'],
          DateTime.parse(e['date']),
        )).toList();
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
          {"content": entryText}
        ), 
        (_) {}, 
        (_) {}
      );

      textCtrl.clear();
      await loadEntries();
    } catch (e) {
      print("Error adding entry: $e");
    }
  }

  Map<String, List<JournalEntry>> groupByDate() {
    final Map<String, List<JournalEntry>> grouped = {};

    for (var entry in journalList) {
      final dateKey = DateFormat('yMMMMd').format(entry.date);
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) =>
          DateFormat('yMMMMd').parse(b).compareTo(DateFormat('yMMMMd').parse(a)));

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  String formatTime(DateTime date) =>
      DateFormat('h:mm a').format(date.toLocal());

  @override
  Widget build(BuildContext context) {
    final groupedEntries = groupByDate();

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
                    horizontal: 24, vertical: 12),
              ),
              child: Text('Save Entry',
                  style: GoogleFonts.caveat(fontSize: 22)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: journalList.isEmpty
                  ? Center(
                      child: Text(
                        'No entries yet.',
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
                                title: Text(
                                  entry.content,
                                  style:
                                      GoogleFonts.caveat(fontSize: 20),
                                ),
                                subtitle: Text(
                                  formatTime(entry.date),
                                  style: GoogleFonts.caveat(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
