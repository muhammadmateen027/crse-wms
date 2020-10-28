import 'package:dio/dio.dart';

class ApiException implements Exception {
  static const defaultErrorDetail = 'Something went wrong. Please try again.';
  DioError error;
  ApiException(DioError error){
    this.error = error;
  }

  String getDetail() {
    if(null == error.response){
      return defaultErrorDetail;
    }
    if (!(null != error.response.data && error.response.data is Map) ){
      return defaultErrorDetail;
    }
    if (!error.response.data.containsKey('errors')){
      return defaultErrorDetail;
    }
    if (error.response.data['errors'] is! List){
      return defaultErrorDetail;
    }

    List<String> details = [];
    error.response.data['errors'].forEach((error) => details.add(error['detail']));

    return details.join('\n\n');
  }

  @override
  String toString(){
    return this.getDetail();
  }
}