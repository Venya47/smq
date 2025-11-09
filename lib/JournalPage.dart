import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Model/journalEntry.dart';
import 'database_services.dart';
// import 'package:uuid/uuid.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firestore = DatabaseServices();
  DateTime _selectedDate = DateTime.now();
  String _selectedMood = 'neutral';

  final Map<String, String> moods = {
    'very_happy': '😁',
    'happy': '🙂',
    'neutral': '😐',
    'sad': '☹️',
    'angry': '😠',
  };

  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final id = const Uuid().v4(); // unique id for local or editing
    final entry = JournalEntry(
      id: id,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      mood: _selectedMood,
      date: _selectedDate,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore.saveEntry(entry);
      // success snackbar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal saved')),
      );
      // clear inputs
      _titleCtrl.clear();
      _contentCtrl.clear();
      setState(() {
        _selectedMood = 'neutral';
        _selectedDate = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildMoodChips() {
    return Wrap(
      spacing: 8,
      children: moods.entries.map((e) {
        final key = e.key;
        final emoji = e.value;
        final isSelected = _selectedMood == key;
        return ChoiceChip(
          label: Text('$emoji  ${key.replaceAll('_', ' ')}'),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedMood = key),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMMd().format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Journal'),
        actions: [
          IconButton(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Select date',
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: $dateStr', style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      hintText: 'What happened today?',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contentCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Journal',
                      hintText: 'Write your thoughts...',
                      alignLabelWithHint: true,
                    ),
                    minLines: 6,
                    maxLines: 12,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Write something' : null,
                  ),
                  const SizedBox(height: 12),
                  const Text('Mood'),
                  const SizedBox(height: 8),
                  _buildMoodChips(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving...' : 'Save Entry'),
                      onPressed: _saving ? null : _save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
