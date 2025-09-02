import 'package:flutter/material.dart';
import 'package:task_manager/widgets/appBar.dart';
import 'dashboardApi.dart'; // Your API file
import 'dashboardModel.dart'; // Your model file

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = DashboardApi.getTasksByUserId(); // fetch user id from JWT or SharedPreferences inside API
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _tasksFuture = DashboardApi.getTasksByUserId();
    });
    await _tasksFuture;
  }
 void _showAddTaskDialog() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter title" : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter description" : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => _isSubmitting = true);

                        try {
                          await DashboardApi.addTask(
                            _titleController.text,
                            _descriptionController.text,
                          );

                          Navigator.of(context).pop();
                          _refreshTasks();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        } finally {
                          setState(() => _isSubmitting = false);
                        }
                      },
                      child: const Text("Submit"),
                    ),
            ],
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  CustomAppBar(
        title: "Active Tasks",
        showBackButton: true,
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No active packs found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final tasks = snapshot.data!;
             return RefreshIndicator(
            onRefresh: () async {
              // Reload the tasks
              setState(() {
                _tasksFuture = DashboardApi.getTasksByUserId();
              });
              // Wait for the Future to complete before ending refresh
              await _tasksFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                // Only display active tasks
                if (task.active != "Y") return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Edit functionality
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            );
          }
        },
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
