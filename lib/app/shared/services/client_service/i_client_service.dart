abstract class IClientService {
  Future<void> post({
    required String url,
    required Object body,
  });
}
