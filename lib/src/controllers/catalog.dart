import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/models/catalog.dart';
import '../services/catalog/interface.dart';


final catalogProvider =
StateNotifierProvider.autoDispose.family<CatalogController, AsyncValue<List<CatalogModel>>, String>((ref, id) {

  return CatalogController(ref, id);
});

class CatalogController extends StateNotifier<AsyncValue<List<CatalogModel>>>{
  final Ref? ref;
  final String? id;
  CatalogController([this.ref, this.id]) : super(const AsyncValue.data([])) {
    getCatalog();
  }


  Future<void> createCatalog({
    required CatalogModel catalogModel
  }) async {
    try {
      final catalog = await ref?.read(catalogServiceProvider).createCatalog(catalogModel: catalogModel);
      return catalog;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<void> editCatalog({
    Map<String, dynamic>? catalogModel
  }) async {
    try {
      final catalog = await ref?.read(catalogServiceProvider).editCatalog(catalogModel: catalogModel);
      return catalog;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }

  Future<List<CatalogModel>> getCatalog() async {
    try {
      final catalogs = await ref?.read(catalogServiceProvider).getCatalogs(id!);
      state = AsyncValue.data(catalogs!);
      return state.value!;
    } on FirebaseException catch (e, _) {
      throw e.message!;
    }
  }
}
