

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/catalog.dart';
import 'package:megas/src/services/catalog/interface.dart';

class CatalogServiceImpl implements CatalogService{
  @override
  Future<void> createCatalog({required CatalogModel catalogModel}) async{
    // TODO: implement createCatalog
    try{
      final catalog =await usersRef.doc(catalogModel.userId).collection('catalogs').doc(catalogModel.id).set(catalogModel.toJson());
      return catalog;
    } on FirebaseException catch (e){
      throw e;
    };
  }

  @override
  Future<List<CatalogModel>> getCatalogs(uid) async{
    // TODO: implement getCatalogs
    final List<CatalogModel> catalogList = [];
    try{
      print('getting catalogs from reference');
      final data = await usersRef.doc(uid).collection('catalogs').get();
      print('iterating over catalogs to convert it to Map<String, dynamic>');
       for (var snapshot in data.docs){
          catalogList.add(
              CatalogModel.fromJson(snapshot.data())
          );
          print('done with iteration');
      }
      print('catalog returned as Map<String, dynamic>');
      return catalogList;
    } on FirebaseException catch (e){
      throw e;
    };
  }

  @override
  Future editCatalog({Map<String, dynamic>? catalogModel, id}) async{
    // TODO: implement editCatalog
    try{
      final catalog = await catalogsRef.doc(id).update(catalogModel!);
      return catalog;
    } on FirebaseException catch (e){
      throw e;
    };
  }
}