// import 'package:objectbox/objectbox.dart';
// import 'objectbox_user.g.dart';

// @Entity()
class UserModel {
  // @Id()
  int localId;
  final String id;
  final String username;
  final String name;
  final String bio;
  final String avatarUrl;
  final String? url;
  final List<dynamic> followersCount;
  final List<dynamic> followingCount;
  final List<dynamic> postsCount;
  final String createdAt;
  UserModel({
    this.localId =0,
    required this.id,
    required this.username,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    this.url,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'],
      name: json['name'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      url: json['url'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      postsCount: json['posts_count'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['bio'] = bio;
    data['avatar_url'] = avatarUrl;
    data['url'] = url;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['posts_count'] = postsCount;
    // data['created_at'] = createdAt;
    return data;
  }

  // Future<UserModel> getProf() async{
  //     final data = await rootBundle.loadString('assets/mock_json_datum/profile.json');
  //     final okay = await geFromJson(data);
  //     return okay;
  // }
  //
  //
  // UserModel geFromJson(dynamic json){///Json
  //   Map<String, dynamic> data = jsonDecode(json);
  //
  //   return UserModel.fromJson(data);
  //   //// use this to get json data
  // }
}