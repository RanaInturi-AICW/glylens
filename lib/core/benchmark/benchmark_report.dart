class BenchmarkReport {
  final bool passed;
  final int totalChecks;
  final int failureCount;
  final List<String> issues;

  BenchmarkReport({
    required this.passed,
    required this.totalChecks,
    required this.failureCount,
    this.issues = const [],
  });

  String get summary {
    if (passed) {
      return 'Benchmark dataset is valid. $totalChecks checks passed.';
    }
    return 'Benchmark dataset failed with $failureCount issues out of $totalChecks checks.';
  }

  Map<String, dynamic> toJson() => {
        'passed': passed,
        'totalChecks': totalChecks,
        'failureCount': failureCount,
        'issues': issues,
      };
}
