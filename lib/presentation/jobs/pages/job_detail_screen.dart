import 'package:flutter/material.dart';
import 'package:interviews_flutter_assignment/data/models/job.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
           
          ],
        ),
      ),
    );
  }
}
