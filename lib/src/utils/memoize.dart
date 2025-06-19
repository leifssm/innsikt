T Function() memoize<T>(T Function() fn) {
  late T cachedValue;
  bool isCached = false;

  return () {
    if (!isCached) {
      cachedValue = fn();
      isCached = true;
    }
    return cachedValue;
  };
}