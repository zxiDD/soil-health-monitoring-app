import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soil_health_app/providers/auth_provider.dart';
import '../../providers/reading_provider.dart';
import '../../models/readings.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final state = ref.watch(readingNotifierProvider);
    final notifier = ref.read(readingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Health App'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: uid == null
                    ? const Text('Not logged in')
                    : StreamBuilder<Reading?>(
                        stream: ref
                            .read(firestoreProvider)
                            .latestReadingStream(uid: uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final reading = snapshot.data;
                          if (reading == null) {
                            return const Text(
                              'No Readings Yet. Tap TEST to Fetch',
                              style: TextStyle(fontSize: 16),
                            );
                          }
                          return _ReadingTile(reading: reading);
                        },
                      ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.loading
                    ? null
                    : () async {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid == null) return;
                        try {
                          await notifier.fetchAndSave(uid: uid);
                          final r = ref.read(readingNotifierProvider).last;
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Saved: ${r!.temperature}°C, ${r.moisture}%'),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('error: $e'),
                            ),
                          );
                        }
                      },
                child: state.loading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Test', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/reports'),
                child: const Text('Reports', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingTile extends StatelessWidget {
  final Reading reading;
  const _ReadingTile({required this.reading});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latest Reading', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${reading.temperature} °C',
                style: const TextStyle(fontSize: 18)),
            Text('${reading.moisture} %', style: const TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 8),
        Text(df.format(reading.timestamp),
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
