import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final DateTime selectedDate;
  final String? taskId;
  const AddTask({super.key, required this.selectedDate, this.taskId});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  Future<void> _saveTask() async {
    String taskName = _taskNameController.text.trim();
    String startTime = _startTimeController.text.trim();
    String endTime = _endTimeController.text.trim();
    
    if (taskName.isNotEmpty && startTime.isNotEmpty && endTime.isNotEmpty) {
      DateTime taskDate = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      );

      if (widget.taskId == null) {
        await FirebaseFirestore.instance.collection('tasks').add({
          'name': taskName,
          'status': false,
          'date': Timestamp.fromDate(taskDate),
          'startTime': startTime,
          'endTime': endTime,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .update({
          'name': taskName,
          'startTime': startTime,
          'endTime': endTime,
        });
      }

      _taskNameController.clear();
      _startTimeController.clear();
      _endTimeController.clear();

      Navigator.of(context).pop();
    } else {
      _showIncompleteFieldsDialog();
    }
  }

  void _showIncompleteFieldsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Fields"),
          content: const Text("Please complete all fields before saving."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.taskId == null ? "Add New Task" : "Edit Task",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _taskNameController,
            decoration: InputDecoration(
              labelText: "Task Name",
              hintText: "Type here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[300],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _startTimeController,
            decoration: InputDecoration(
              labelText: "Start Time (e.g., 10:00 AM)",
              hintText: "Enter start time",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[300],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _endTimeController,
            decoration: InputDecoration(
              labelText: "End Time (e.g., 12:00 PM)",
              hintText: "Enter end time",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[300],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveTask,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: Text(
              widget.taskId == null ? "Add Task" : "Save Changes",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
