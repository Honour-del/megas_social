
import 'dart:convert';

class CatalogModel {
  CatalogModel({
    required this.userId,
    required this.id,
    required this.description,
    required this.images,
    required this.itemQuantity,
    required this.itemName,
    required this.itemPrice,
    this.link,
    this.time
  });
  late final String id;
  late final String description;
  late final String userId;
  late final String images;
  late final String itemName;
  late final int itemQuantity;
  late final double itemPrice;
  late final String? link;
  late final String? time;

  CatalogModel.fromJson(json) {
    // List<ImageM>? images = (json['images'] as List).map((e) => ImageM.fromJson(e)).toList();
    id = json['catalog_id'] ?? '';
    images = json['images'] ?? '';  //List.castFrom<dynamic, String>(json['images'] ?? [])
    description = json['description'] ?? '';
    userId = json['user_id'] ?? '';
    itemPrice = json['price'] ?? '';
    // likes = List.castFrom<dynamic, String>(json['likes'] ?? []);
    itemName = json['name'] ?? '';
    itemQuantity= json['quantity'] ?? '';
    link = json['link'] ?? '';
    time = json['time_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['catalog_id'] = id;
    data['images'] = images;
    // data['images'] = images?.map((e) => e.toJson()).toList();
    data['name'] = itemName;
    data['user_id'] = userId;
    data['quantity'] = itemQuantity;
    data['price'] = itemPrice;
    data['link'] = link;
    data['description'] = description;
    return data;
  }

  CatalogModel getCatalogFromJson(dynamic json){///Json
    Map<String, dynamic> data = jsonDecode(json);

    return CatalogModel.fromJson(data);
    //// use this to get json data
  }
}

class ImageM {
  ImageM({required this.id, required this.image,});
  final int id;
  final String image;


  factory ImageM.fromJson(Map<String, dynamic> json){
    return ImageM(
        id: json["id"],
        image: json["image"]
    );
  }

  Map<String, dynamic> toJson(){
    final json = <String, dynamic>{};
    json["image"] = image;
    return json;
  }
}