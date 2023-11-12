import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kordi_mobile/collections/interfaces/collections_interface.dart';
import 'package:kordi_mobile/collections/models/collection_filter.dart';
import 'package:kordi_mobile/collections/models/collections_models.dart';
import 'package:kordi_mobile/core/models/kordi_exception.dart';
import 'package:kordi_mobile/core/utils/dio_client.dart';
import 'package:kordi_mobile/dependency_injection.dart';
import 'package:kordi_mobile/sign_up/utils/response_code_converter.dart';

@Singleton(as: CollectionsInterface)
class CollectionsService implements CollectionsInterface {
  @override
  Future<Either<KordiException, CollectionPaging>> getFilteredCollections(
    CollectionFilter dto,
  ) async {
    log('[CollectionsService] getFilteredCollections()');
    late Either<KordiException, CollectionPaging> result;
    final DioClient _dioClient = getIt.get<DioClient>();
    final String pathParameters = dto.toPathParameters;
    try {
      final response = await _dioClient.dio.get(
        '/collections?$pathParameters',
      );

      final CollectionPaging collectionPaging =
          CollectionPaging.fromJson(response.data);
      result = right(collectionPaging);
    } on DioException catch (e, s) {
      log(
        '[CollectionsService] getFilteredCollections()',
        error: e,
        stackTrace: s,
      );
      if (e.response?.statusCode == 401) {
        result = left(KordiException.unauthorized());
      } else {
        final String message =
            ResponseCodeConverter.convert(e.response?.data['error']);
        result = left(
          KordiException.customMessage(message: message),
        );
      }
    }
    return result;
  }

  @override
  Future<Either<KordiException, CollectionPaging>> get() async {
    log('[CollectionsService] getFilteredCollections()');
    late Either<KordiException, CollectionPaging> result;
    final DioClient _dioClient = getIt.get<DioClient>();
    try {
      final response = await _dioClient.dio.get(
        '/collections',
      );

      final CollectionPaging collectionPaging =
          CollectionPaging.fromJson(response.data);
      result = right(collectionPaging);
    } on DioException catch (e, s) {
      log(
        '[CollectionsService] get()',
        error: e,
        stackTrace: s,
      );
      if (e.response?.statusCode == 401) {
        result = left(KordiException.unauthorized());
      } else {
        final String message =
            ResponseCodeConverter.convert(e.response?.data['error']);
        result = left(
          KordiException.customMessage(message: message),
        );
      }
    }
    return result;
  }
}
