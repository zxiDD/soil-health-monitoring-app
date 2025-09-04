import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/readings.dart';
import '../core/services/bluetooth_service.dart';
import '../core/services/firestore_service.dart';

final bluetoothProvider =
    Provider<BluetoothService>((ref) => BluetoothService(mock: true));
final firestoreProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

class ReadingState {
  final Reading? last;
  final bool loading;
  final String? error;

  ReadingState({this.last, this.loading = false, this.error});
  ReadingState copyWith({Reading? last, bool? loading, String? error}) =>
      ReadingState(
        last: last ?? this.last,
        loading: loading ?? this.loading,
        error: error ?? this.error,
      );
  factory ReadingState.initial() => ReadingState();
}

class ReadingNotifier extends StateNotifier<ReadingState> {
  final BluetoothService _bt;
  final FirestoreService _fs;

  ReadingNotifier(this._bt, this._fs) : super(ReadingState.initial());

  Future<void> fetchAndSave({String? uid}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reading = await _bt.fetchReading();
      await _fs.saveReading(reading, uid: uid!);
      state = state.copyWith(last: reading, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow;
    }
  }

  void setLast(Reading r) => state = state.copyWith(last: r);
}

final readingNotifierProvider =
    StateNotifierProvider<ReadingNotifier, ReadingState>((ref) {
  final bt = ref.read(bluetoothProvider);
  final fs = ref.read(firestoreProvider);
  return ReadingNotifier(bt, fs);
});
