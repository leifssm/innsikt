import 'dart:async';

class GentleQuerier<T, U> {
  final Future<T> Function(U arg) _query;
  late final List<U> _args;
  late final List<T?> _results;

  int _currentIndex = 0;
  int _completed = 0;
  final int window;
  final int maxRetries;
  late final List<int> _retries;

  final _allCompleted = Completer<List<T>>();

  GentleQuerier._(
    this._query,
    List<U> args, {
    this.window = 2,
    this.maxRetries = 1,
  }) {
    assert(window > 0, 'Window size must be greater than 0');
    assert(maxRetries >= 0, 'Max retries must be non-negative');
    assert(args.isNotEmpty, 'Arguments list cannot be empty');

    _args = args;
    _results = List.filled(_args.length, null, growable: false);
    _retries = List.filled(_args.length, 0, growable: false);
  }

  Future<T> _queryIndex(int index) async {
    while (_retries[index] <= maxRetries) {
      try {
        return await _query(_args[index]);
      } catch (e) {
        _retries[index]++;
      }
    }
    throw GentleQuerierException.maxRetriesExceeded(index);
  }

  void _setResult(int index, T result) {
    _results[index] = result;
    _completed++;
    if (_completed == _args.length) {
      _allCompleted.complete(_results.whereType<T>().toList());
    } else {
      _queryNext();
    }
  }

  void _queryNext() {
    if (_currentIndex >= _args.length) return;

    final index = _currentIndex++;
    _queryIndex(index).then((result) => _setResult(index, result));
  }

  static Future<List<T>> query<T, U>(
    Future<T> Function(U arg) query,
    List<U> args, {
    int window = 2,
    int maxRetries = 0,
  }) async {
    if (args.isEmpty) {
      return Future.value([]);
    }

    final gentle = GentleQuerier._(
      query,
      args,
      window: window,
      maxRetries: maxRetries,
    );
    
    for (var i = 0; i < window; i++) {
      gentle._queryNext();
    }

    return gentle._allCompleted.future;
  }
}

class GentleQuerierException implements Exception {
  final String message;
  final int index;

  GentleQuerierException._(this.message, this.index);

  static GentleQuerierException maxRetriesExceeded(int index) {
    return GentleQuerierException._("Max retries exceeded", index);
  }

  @override
  String toString() => 'GentleQuerierException at index $index: $message';
}