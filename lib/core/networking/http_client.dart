/// HTTP client abstraction for future API integrations (Build Program 2+).
abstract interface class HttpClient {
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
  });
}

class NoOpHttpClient implements HttpClient {
  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('HTTP client not configured in Build Program 1');
  }
}
