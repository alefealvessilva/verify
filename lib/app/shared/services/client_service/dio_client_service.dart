import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:verify/app/shared/services/client_service/i_client_service.dart';

class DioClientService implements IClientService {
  final dio = Dio();
  @override
  Future<void> post({
    required String url,
    required Object body,
  }) async {
    try {
      await dio.post(url, data: body);
    } catch (e) {
      log(e.toString());
    }
  }
}
