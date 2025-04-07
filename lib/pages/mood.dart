import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

class ReminderNotePage extends StatefulWidget {
  @override
  _ReminderNotePageState createState() => _ReminderNotePageState();
}

class _ReminderNotePageState extends State<ReminderNotePage> {
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDateTime;
  List<Map<String, dynamic>> _reminders = [];

  void _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveReminder() {
    String note = _noteController.text.trim();
    if (note.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a note and pick a time')),
      );
      return;
    }

    setState(() {
      _reminders.add({
        'note': note,
        'time': _selectedDateTime!,
      });
      _noteController.clear();
      _selectedDateTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder saved!')),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder Notes', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),)),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset(
              'assets/notes_back.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'Enter your note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _selectedDateTime == null
                        ? 'No reminder set'
                        : 'Reminder: ${_formatDateTime(_selectedDateTime!)}',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: _pickDateTime,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveReminder,
                  child: Text('Save Reminder'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                ),
                Divider(height: 32),
                Expanded(
                  child: _reminders.isEmpty
                      ? Center(child: Text('No reminders yet'))
                      : ListView.builder(
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(reminder['note']),
                          subtitle:
                          Text(_formatDateTime(reminder['time'])),
                          leading: Icon(Icons.notifications_active),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
