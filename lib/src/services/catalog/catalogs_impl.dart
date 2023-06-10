

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/references/firestore.dart';
import 'package:megas/src/models/catalog.dart';
import 'package:megas/src/services/catalog/interface.dart';

class CatalogServiceImpl implements CatalogService{
  @override
  Future<void> createCatalog({required CatalogModel catalogModel}) async{
    // TODO: implement createCatalog
    try{
      // final catalog = await usersRef.doc(catalogModel.userId).collection('catalogs').doc(catalogModel.id).set(catalogModel.toJson());
      final catalog = await catalogsRef.doc(catalogModel.id).set(catalogModel.toJson());
      return catalog;
    } on FirebaseException catch (e){
      throw e;
    }
  }

  @override
  Future<List<CatalogModel>> getCatalogs(uid) async{
    // TODO: implement getCatalogs
    final List<CatalogModel> catalogList = [];
    try{
      print('getting catalogs from reference');
      // final data = await usersRef.doc(uid).collection('catalogs').get();
      final data = await catalogsRef.where('user_id', isEqualTo: uid).get();
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
    }
  }

  @override
  Future editCatalog({Map<String, dynamic>? catalogModel, id}) async{
    // TODO: implement editCatalog
    try{
      final catalog = await catalogsRef.doc(id).update(catalogModel!);
      return catalog;
    } on FirebaseException catch (e){
      throw e;
    }
  }
}


final cartProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});
class CartProvider extends ChangeNotifier{
  int _count = 0;
  int get count => _count;

  increment(int value){
    _count = value++;
    notifyListeners();
  }

  decrement(int value){
    _count = value--;
    notifyListeners();
  }
}