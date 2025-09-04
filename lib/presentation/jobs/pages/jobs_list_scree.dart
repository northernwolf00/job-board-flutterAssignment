import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviews_flutter_assignment/data/repositories/job_repository.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/auth/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/state.dart';
import 'package:go_router/go_router.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobBloc(repository: JobRepository())..add(LoadJobs()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jobs List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(Logout());
              },
            ),
          ],
        ),
        body: BlocConsumer<JobBloc, JobState>(
          listener: (context, state) {
            if (state is JobError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is JobLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JobLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.jobs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final job = state.jobs[index];
                  return ListTile(
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      job.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${job.company}\n${job.description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      job.status.toUpperCase(),
                      style: TextStyle(
                        color: job.status == 'open' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Navigate using GoRouter
                      GoRouter.of(context).go('/jobs/${job.id}', extra: job);
                    },
                  );
                },
              );
            } else if (state is JobError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
