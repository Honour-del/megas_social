class UserModel {
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
  final createdAt;
  final fcm_token;

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
    this.fcm_token,
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
      fcm_token: json['fcm_token'] ?? '',
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
    // data['fcm_token'] = fcm_token;
    // data['created_at'] = createdAt;
    return data;
  }
}