import 'package:flutter/material.dart'; 
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