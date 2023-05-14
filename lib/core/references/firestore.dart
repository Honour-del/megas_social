import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef= FirebaseFirestore.instance.collection("posts");
final commentsRef = FirebaseFirestore.instance.collection("comments");
// final feedRef = FirebaseFirestore.instance.collection("feed");
final messagesRefs = FirebaseFirestore.instance.collection("messages");
final notificationsRef = FirebaseFirestore.instance.collection("notifications");
final followingRef = FirebaseFirestore.instance.collection('followings');
final followersRef = FirebaseFirestore.instance.collection('followers');
final chatsRef = FirebaseFirestore.instance.collection('chats');
final catalogsRef = FirebaseFirestore.instance.collection('catalogs');
final likesRef = FirebaseFirestore.instance.collection('likes');
final profileRef = FirebaseFirestore.instance.collection('profileId');
var storageRef = FirebaseStorage.instance.ref();
