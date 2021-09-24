import 'package:dio/dio.dart';
import 'package:frontend/check/domain/check_info.dart';
import 'package:frontend/check/infrastructure/check_info_dto.dart';
import 'package:frontend/core/infrastructure/dio_extensions.dart';
import 'package:frontend/core/infrastructure/network_exceptions.dart';
import 'package:frontend/core/infrastructure/remote_response.dart';
import 'package:frontend/core/presentation/constants/constants.dart';

class CheckInfoRemoteService {
  final Dio _dio;

  const CheckInfoRemoteService(this._dio);

  Future<RemoteResponse<CheckInfoDTO>> fetchCheckInfo(
      String tagId, String interval) async {
    try {
      final response = await _dio.get("/check", queryParameters: {
        "check-no": tagId,
        "sys-flag": LogicConstants.systemFlag,
        "comp-cd": LogicConstants.companyCd,
        // TODO: USER, COMP_CD 값 빼기
        "user": "dev",
        "interval": interval
      });
      if (response.statusCode != 200) {
        throw RestApiException(errorCode: response.statusCode);
      }

      final data = response.data as Map<String, dynamic>;

      if (data.isEmpty) {
        // TODO: 없을 때?
      }

      return RemoteResponse.withNewData(CheckInfoDTO.fromJson(data));
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw RestApiException(errorCode: e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<RemoteResponse<String>> saveCheckResults(
      Map<String, dynamic> params, List<CheckImage> images) async {
    try {
      await _saveCheckInfoResult(params);
      await _saveCheckImages(images);

      return const RemoteResponse.withNewData("OK");
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw RestApiException(errorCode: e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _saveCheckInfoResult(Map<String, dynamic> params) async {
    try {
      final response = await _dio.post("/check", data: params);
      if (response.statusCode != 200) {
        throw RestApiException(errorCode: response.statusCode);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw RestApiException(errorCode: e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _saveCheckImages(List<CheckImage> images) async {
    try {
      final formData = FormData();
      final imageParams = <MapEntry<String, MultipartFile>>[];

      for (final image in images) {
        final img =
            MultipartFile.fromFileSync(image.image.path, filename: image.name);
        imageParams.add(MapEntry("file", img));
      }

      formData.files.addAll(imageParams);

      final response = await _dio.post("/check/images", data: formData);
      if (response.statusCode != 200) {
        throw RestApiException(errorCode: response.statusCode);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw RestApiException(errorCode: e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}