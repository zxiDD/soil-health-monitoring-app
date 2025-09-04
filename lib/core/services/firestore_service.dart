import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/readings.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveReading(Reading r, {required String uid}) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('readings')
        .add(r.toMap());
  }

  Stream<List<Reading>> readingsStream({required String uid, int limit = 100}) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('readings')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
            (snap) => snap.docs.map((d) => Reading.fromMap(d.data())).toList());
  }

  Future<Reading?> latestReading({required String uid}) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('readings')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return Reading.fromMap(snap.docs.first.data());
  }

  Stream<Reading?> latestReadingStream({required String uid}) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('readings')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) =>
            snap.docs.isEmpty ? null : Reading.fromMap(snap.docs.first.data()));
  }
}
