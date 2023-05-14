

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/catalog.dart';
import 'package:megas/src/services/catalog/catalogs_impl.dart';


final catalogServiceProvider = Provider((ref) {
  return CatalogService();
});

abstract class CatalogService {

  factory CatalogService()=> CatalogServiceImpl();

  // var uuid = const Uuid();
  /*
  All these class id's are commented out because
  the decision is to be made  by backend engineer if
  each class id's are to be generated on the backend
  or from the frontend!!!!!.

  Because if the id's are randomly generated from the backend
  i wont need to post id toJson it will/can only be returned fromJson
  */
  Future<void> createCatalog({required CatalogModel catalogModel});

  Future<void> editCatalog({Map<String, dynamic>? catalogModel, id});

  /// get created catalog by of each user by each user from the database
  Future<List<CatalogModel>> getCatalogs(uid);
}