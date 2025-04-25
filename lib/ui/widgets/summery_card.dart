import 'package:flutter/material.dart';

class SummeryCard extends StatelessWidget {
  const SummeryCard({
    super.key, required this.title, required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("$count",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
            Text(title,style: TextStyle(color: Colors.grey),),
          ],
        ),
      ),
    );
  }
}