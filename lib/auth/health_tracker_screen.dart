import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class HealthTrackerScreen extends StatefulWidget {
  const HealthTrackerScreen({Key? key}) : super(key: key);

  @override
  State<HealthTrackerScreen> createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  int? _selectedMood;
  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😊', 'label': 'Great', 'color': Color(0xFF10B981)},
    {'emoji': '😌', 'label': 'Good', 'color': Color(0xFF3B82F6)},
    {'emoji': '😐', 'label': 'Okay', 'color': Color(0xFFF59E0B)},
    {'emoji': '😔', 'label': 'Low', 'color': Color(0xFFEF4444)},
    {'emoji': '😫', 'label': 'Bad', 'color': Color(0xFF991B1B)},
  ];

  final List<Map<String, dynamic>> _symptoms = [
    {'name': 'Nausea', 'icon': Icons.sick_outlined},
    {'name': 'Fatigue', 'icon': Icons.bedtime_outlined},
    {'name': 'Headache', 'icon': Icons.psychology_outlined},
    {'name': 'Back pain', 'icon': Icons.accessibility_new_outlined},
    {'name': 'None', 'icon': Icons.check_circle_outline},
  ];

  final Set<String> _selectedSymptoms = {};
  final TextEditingController _notesController = TextEditingController();

  final CollectionReference _healthCollection =
  FirebaseFirestore.instance.collection('health_tracker');
  final CollectionReference _medicationCollection =
  FirebaseFirestore.instance.collection('medications');

  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _medTimeController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    var androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _saveHealthEntry() async {
    if (_selectedMood == null &&
        _selectedSymptoms.isEmpty &&
        _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one field'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    await _healthCollection.add({
      'mood': _selectedMood,
      'symptoms': _selectedSymptoms.toList(),
      'notes': _notesController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _selectedMood = null;
      _selectedSymptoms.clear();
      _notesController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Health entry saved successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _deleteHealthEntry(String id) async {
    await _healthCollection.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Entry deleted'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleMedication(String id, bool currentStatus) async {
    await _medicationCollection.doc(id).update({'taken': !currentStatus});
  }

  void _deleteMedication(String id) async {
    await _medicationCollection.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Medication deleted'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _addMedication() async {
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.medication, color: Color(0xFFA78BFA)),
              SizedBox(width: 12),
              Text('Add Medication'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _medNameController,
                decoration: InputDecoration(
                  labelText: 'Medication Name',
                  prefixIcon: const Icon(Icons.local_pharmacy, color: Color(0xFFC239B3)),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    selectedTime = time;
                    _medTimeController.text = time.format(context);
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _medTimeController,
                    decoration: InputDecoration(
                      labelText: 'Time (tap to select)',
                      prefixIcon: const Icon(Icons.access_time, color: Color(0xFFC239B3)),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _medNameController.clear();
                _medTimeController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _medNameController.text.trim();
                if (name.isNotEmpty && selectedTime != null) {
                  await _medicationCollection.add({
                    'name': name,
                    'time': _medTimeController.text,
                    'taken': false,
                  });

                  await scheduleMedicationReminder(name, selectedTime!);

                  _medNameController.clear();
                  _medTimeController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Medication reminder added!'),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC239B3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> scheduleMedicationReminder(String medName, TimeOfDay time) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'med_channel',
      'Medication Reminder',
      channelDescription: 'Reminder for taking medications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      medName.hashCode,
      'Medication Reminder',
      'Time to take $medName 💊',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Gradient App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFA78BFA),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Health Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB794F4), Color(0xFF9C27B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mood Section
                  _buildSectionTitle('How are you feeling today?', Icons.mood),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _moods.length,
                            (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMood = index;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedMood == index
                                      ? _moods[index]['color'].withOpacity(0.15)
                                      : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: _selectedMood == index
                                        ? _moods[index]['color']
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  _moods[index]['emoji'],
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _moods[index]['label'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _selectedMood == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: _selectedMood == index
                                      ? _moods[index]['color']
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Symptoms Section
                  _buildSectionTitle('Any symptoms?', Icons.health_and_safety),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _symptoms.map((symptom) {
                        final isSelected = _selectedSymptoms.contains(symptom['name']);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected)
                                _selectedSymptoms.remove(symptom['name']);
                              else
                                _selectedSymptoms.add(symptom['name']);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                colors: [Color(0xFFC239B3), Color(0xFFE91E63)],
                              )
                                  : null,
                              color: isSelected ? null : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  symptom['icon'],
                                  size: 18,
                                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  symptom['name'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notes Section
                  _buildSectionTitle('Additional Notes', Icons.edit_note),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Any additional notes about how you\'re feeling...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB794F4), Color(0xFFA78BFA)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB794F4).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _saveHealthEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, color: Colors.white),
                          SizedBox(width: 12),
                          Text(
                            'Save Entry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Previous Entries
                  _buildSectionTitle('Health History', Icons.history),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: _healthCollection
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return _buildEmptyState(
                          'No health entries yet',
                          'Start tracking your health today!',
                          Icons.favorite_border,
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final moodIndex = data['mood'] as int?;
                          final mood = moodIndex != null && moodIndex < _moods.length
                              ? _moods[moodIndex]['emoji']
                              : '🙂';
                          final symptoms = List<String>.from(data['symptoms'] ?? []);
                          final notes = data['notes'] ?? '';
                          final timestamp = data['timestamp'] as Timestamp?;
                          final date = timestamp != null
                              ? DateFormat('MMM dd, yyyy - hh:mm a')
                              .format(timestamp.toDate())
                              : 'Unknown date';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCE7F3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(mood, style: const TextStyle(fontSize: 28)),
                              ),
                              title: Text(
                                symptoms.isNotEmpty ? symptoms.join(', ') : 'No symptoms',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  if (notes.isNotEmpty)
                                    Text(
                                      notes,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 14, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                                onPressed: () => _deleteHealthEntry(doc.id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Medication Reminders Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Medication Reminders', Icons.medication),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB794F4), Color(0xFFB794F4)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: _addMedication,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Medication List
                  StreamBuilder<QuerySnapshot>(
                    stream: _medicationCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final meds = snapshot.data!.docs;
                      if (meds.isEmpty) {
                        return _buildEmptyState(
                          'No medications added',
                          'Add reminders for your medications',
                          Icons.medication_outlined,
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: meds.length,
                        itemBuilder: (context, index) {
                          final med = meds[index];
                          final data = med.data() as Map<String, dynamic>;
                          final name = data['name'] ?? '';
                          final time = data['time'] ?? '';
                          final taken = data['taken'] ?? false;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: taken
                                    ? const Color(0xFF10B981).withOpacity(0.3)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: GestureDetector(
                                onTap: () => _toggleMedication(med.id, taken),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: taken
                                        ? const Color(0xFF10B981).withOpacity(0.1)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    taken ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: taken ? const Color(0xFF10B981) : Colors.grey,
                                    size: 32,
                                  ),
                                ),
                              ),
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: taken ? TextDecoration.lineThrough : null,
                                  color: taken ? Colors.grey : const Color(0xFF1F2937),
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16, color: Color(0xFFB794F4)),
                                  const SizedBox(width: 6),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      color: Color(0xFFB794F4),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                                onPressed: () => _deleteMedication(med.id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB794F4), Color(0xFFB794F4)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: const Color(0xFFB794F4)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}