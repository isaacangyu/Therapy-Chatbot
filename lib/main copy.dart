import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(JournalApp());
}

class JournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Journal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.caveatTextTheme(),
      ),
      home: JournalPage(),
    );
  }
}

class JournalEntry {
  final String content;
  final DateTime date;
  JournalEntry(this.content, this.date);
}

class JournalPage extends StatefulWidget {
  @override
  JournalPageState createState() => JournalPageState();
}

class JournalPageState extends State<JournalPage> {
  final TextEditingController textCtrl = TextEditingController();
  final List<JournalEntry> journalList = [];

  void addEntry() {
    final entryText = textCtrl.text.trim();
    if (entryText.isNotEmpty) {
      setState(() {
        final now = DateTime.now().toLocal();
        journalList.insert(0, JournalEntry(entryText, now));
        textCtrl.clear();
      });
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

  String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date.toLocal());
  }

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
              maxLines: 5,
              style: GoogleFonts.caveat(
                color: Colors.brown.shade800,
                fontSize: 22,
              ),
              decoration: InputDecoration(
                hintText: 'Write your thoughts here...',
                hintStyle: GoogleFonts.caveat(
                  color: Colors.brown.shade400,
                  fontSize: 22,
                ),
                filled: true,
                fillColor: Colors.brown.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save Entry',
                style: GoogleFonts.caveat(fontSize: 22),
              ),
            ),
            const SizedBox(height: 16),
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
                            tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            iconColor: Colors.green.shade800,
                            collapsedIconColor: Colors.green.shade800,
                            title: Text(
                              group.key,
                              style: GoogleFonts.caveat(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                                fontSize: 24,
                              ),
                            ),
                            children: group.value.map((entry) {
                              return ListTile(
                                leading: Icon(Icons.bookmark,
                                    color: Colors.green.shade700),
                                title: Text(
                                  entry.content,
                                  style: GoogleFonts.caveat(fontSize: 22),
                                ),
                                subtitle: Text(
                                  formatTime(entry.date),
                                  style: GoogleFonts.caveat(
                                    color: Colors.grey[700],
                                    fontSize: 18,
                                  ),
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