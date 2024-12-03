import 'dart:async';
import 'dart:io';

import 'package:florist/app/modules/flower_care_reminder/services/notificationservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class FlowerCareReminderView extends StatefulWidget {
  const FlowerCareReminderView({Key? key}) : super(key: key);

  @override
  State<FlowerCareReminderView> createState() => _FlowerCareReminderViewState();
}

class _FlowerCareReminderViewState extends State<FlowerCareReminderView> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> tasks = [];
  Timer? reminderTimer;

  @override
  void initState() {
    super.initState();
    _startReminderChecker();
  }

  @override
  void dispose() {
    reminderTimer?.cancel();
    super.dispose();
  }

  void _startReminderChecker() {
    reminderTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      for (var task in tasks) {
        // Cek jika waktu pengingat sesuai dengan waktu saat ini
        if (task.containsKey('scheduledTime') &&
            task['scheduledTime'].hour == now.hour &&
            task['scheduledTime'].minute == now.minute) {
          _showReminder(task['title']);
        }
      }
    });
  }

  // void _showReminder(String title) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Waktunya $title"),
  //       duration: const Duration(seconds: 5),
  //     ),
  //   );
  // }
  void _showReminder(String title) {
    Get.snackbar(
      'Reminder',
      'Waktunya $title',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey,
      colorText: Colors.black,
      icon: Icon(IconlyLight.notification),
      duration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> upcomingDates = List.generate(
      10,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengingat Perawatan Tanaman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskDialog(context);
        },
        backgroundColor: Colors.green.withOpacity(0.8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              DateFormat('MMMM, d').format(selectedDate),
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: upcomingDates.map((date) {
                  bool isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.4),
                                    blurRadius: 10)
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('d').format(date),
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEE').format(date),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tugas',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada tugas',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tekan tombol + untuk menambah tugas baru',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return buildTaskCard(
                          task['status'],
                          task['title'],
                          task['time'],
                          task['color'],
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddTaskDialog(BuildContext context) {
    final _statusController = TextEditingController();
    final _titleController = TextEditingController();
    final _timeController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Tugas Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: "Harian", child: Text("Harian")),
                  DropdownMenuItem(value: "3 Hari", child: Text("3 Hari")),
                  DropdownMenuItem(value: "1 Minggu", child: Text("1 Minggu")),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _statusController.text = newValue;
                  }
                },
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Judul Tugas"),
              ),
              GestureDetector(
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    selectedTime = pickedTime;
                    _timeController.text = "${pickedTime.format(context)} WIB";
                  }
                },
                child: TextField(
                  controller: _timeController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Waktu",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                if (selectedTime != null && _statusController.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      'status': _statusController.text,
                      'title': _titleController.text,
                      'time': _timeController.text,
                      'color': Colors.blue,
                      'scheduledTime': DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      ),
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child:
                  const Text("Tambah", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Widget buildTaskCard(String status, String title, String time, Color color, int index) {
    return Dismissible(
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red,
        ),
        
        child: const Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          tasks.removeAt(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.access_time, color: color, size: 32),
          ],
        ),
      ),
    );
  }
}
