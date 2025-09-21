import 'package:flutter/material.dart'; 
import 'icon_label.dart';
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