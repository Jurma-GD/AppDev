import 'package:flutter/material.dart'; 
 
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
    }, 
    { 
      'title': 'Refactor auth', 
      'description': 'Move logic into a reusable AuthService and clean up UI.', 
      'priority': 'Low', 
    }, 
    { 
      'title': 'Design review', 
      'description': 'Prepare slides for Friday review with product.', 
      'priority': 'High', 
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
 
/// --------------------------- 
/// Widget: TaskCard (Stateless) 
/// --------------------------- 
/// You can extract this to its own file: widgets/task_card.dart 
class TaskCard extends StatelessWidget { 
  final String title; 
  final String description; 
  final String priority; 
  final String? dueDate; // new 
  final String? assignee; // new 

  const TaskCard({ 
    super.key, 
    required this.title, 
    required this.description, 
    required this.priority, 
    this.dueDate, 
    this.assignee,
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Card( 
      elevation: 2, 
      child: Padding( 
        padding: const EdgeInsets.all(12), 
        child: Row( 
          children: [ 
            Expanded( 
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                Row( 
                  children: [ 
                    Expanded(child: Text(title, style: 
Theme.of(context).textTheme.titleMedium)), 
                    // small hint to show composition: IconLabel can be reused elsewhere 
                    IconLabel(icon: Icons.calendar_month, label: dueDate ?? 'No due date'), 
                  ], 
                ), 
                const SizedBox(height: 6), 
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis), 
                const SizedBox(height: 8), 
                Row(children: [ 
                  IconLabel(icon: Icons.comment, label: '2 comments'), 
                  const SizedBox(width: 12), 
                  IconLabel(icon: Icons.done, label: '2 works done'),
                  const SizedBox(width: 12), 
                  IconLabel(icon: Icons.person_outline, label: assignee ?? 'Unassigned'), 
                ]), 
              ]), 
            ), 
            const SizedBox(width: 12), 
            _PriorityBadge(priority: priority), 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 
/// Small private sub-widget (extractable) 
class _PriorityBadge extends StatelessWidget { 
  final String priority; 
  const _PriorityBadge({super.key, required this.priority}); 
 
  Color get _color => priority.toLowerCase() == 'high' ? Colors.red : Colors.green; 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
      decoration: BoxDecoration(color: _color.withOpacity(0.12), borderRadius: 
BorderRadius.circular(12)), 
      child: Text(priority, style: TextStyle(color: _color, fontWeight: 
FontWeight.w600)), 
    ); 
  } 
} 
 
/// --------------------------- 
/// Reusable IconLabel widget 
/// --------------------------- 
class IconLabel extends StatelessWidget { 
  final IconData icon; 
  final String label; 
  const IconLabel({super.key, required this.icon, required this.label}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Row( 
      children: [ 
        Icon(icon, size: 16), 
        const SizedBox(width: 6), 
        Text(label, style: Theme.of(context).textTheme.bodyMedium), 
      ], 
    ); 
} 
}