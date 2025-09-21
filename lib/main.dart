import 'package:flutter/material.dart'; 
import 'widgets/task_card.dart';
 
void main() => runApp(const TaskApp()); 
 
class TaskApp extends StatelessWidget { 
  const TaskApp({super.key}); 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Widget Fundamentals Demo', 
      theme: ThemeData(useMaterial3: true), 
      home: const TaskListPage(), 
    ); 
  } 
} 
 
class TaskListPage extends StatelessWidget { 
  const TaskListPage({super.key}); 
 
  static final _demoTasks = [ 
    { 
      'title': 'Write unit tests', 
      'description': 'Cover TaskCard widget and interactive behavior.', 
      'priority': 'High', 
      'dueDate': '2025-9-21',
      'assignee': 'Jurma',
    }, 
    { 
      'title': 'Refactor auth', 
      'description': 'Move logic into a reusable AuthService and clean up UI.', 
      'priority': 'Low', 
      'dueDate': '2025-10-01',
    }, 
    { 
      'title': 'Design review', 
      'description': 'Prepare slides for Friday review with product.', 
      'priority': 'High', 
    }, 
    {
      'title': 'Daily standup',
      'description': 'Share progress and blockers with the team.',
      'priority': 'Medium',
      'dueDate': '2027-2-28',
      'assignee': 'Franz',
    },
    {
      'title': 'Update documentation',
      'description': 'Add new API endpoints and usage examples.',
      'priority': 'High',
      'assignee': 'Ivonne',
    },
  ]; 
  
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text('Tasks')), 
      body: ListView.separated( 
        padding: const EdgeInsets.all(12), 
        itemCount: _demoTasks.length, 
        separatorBuilder: (_, __) => const SizedBox(height: 8), 
        itemBuilder: (context, i) { 
          final t = _demoTasks[i]; 
          return TaskCard( 
            title: t['title']!, 
            description: t['description']!, 
            priority: t['priority']!, 
            dueDate: t['dueDate'],
            assignee: t['assignee'],
          ); 
        }, 
      ), 
      floatingActionButton: FloatingActionButton( 
        onPressed: () => _openAddModal(context), 
        child: const Icon(Icons.add), 
      ), 
    ); 
  } 
 
  void _openAddModal(BuildContext context) { 
    showModalBottomSheet( 
      context: context, 
      isScrollControlled: true, 
      builder: (_) { 
        return const AddTaskModal();
      }, 
    ); 
  } 
} 
 
class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  String selectedPriority = 'High';
  final _titleController = TextEditingController(text: 'Weekly sync notes');
  final _descController = TextEditingController(text: 'Discuss project status, blockers, and next steps.');

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Task',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            child: DropdownButton<String>(
              value: selectedPriority,
              isExpanded: true,
              underline: const SizedBox(),
              items: ['High', 'Medium', 'Low']
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          p,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => selectedPriority = v!),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('(UI-only) Task created')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Create (UI only)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
 
