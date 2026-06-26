/// Future certificate pinning hook (not enabled in Build Program 1).
abstract interface class CertificatePinningService {
  Future<void> initialize({required List<String> pinnedSha256});

  bool get isEnabled;
}

class NoOpCertificatePinningService implements CertificatePinningService {
  @override
  Future<void> initialize({required List<String> pinnedSha256}) async {}

  @override
  bool get isEnabled => false;
}
