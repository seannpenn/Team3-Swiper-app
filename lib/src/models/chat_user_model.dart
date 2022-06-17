import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiper_app/src/models/chat_message_model.dart';

class ChatUser {
  final String uid, username, email, image, bio;
  List<String> friends, request;
  Timestamp created, updated;

  ChatUser(
      {required this.uid,
      required this.username,
      required this.email,
      required this.image,
      this.bio = '',
      this.friends = const [],
      this.request = const [],
      created,
      updated})
      : created = created ?? Timestamp.now(),
        updated = updated ?? Timestamp.now();

  static ChatUser fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatUser(
      uid: snap.id,
      friends: json['friends'] != null
          ? List<String>.from(json['friends'])
          : <String>[],
      request: json['request'] != null
          ? List<String>.from(json['request'])
          : <String>[],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? " ",
      bio: json['bio'] ?? "",
      created: json['created'] ?? Timestamp.now(),
      updated: json['updated'] ?? Timestamp.now(),
    );
  }

  static Future<ChatUser> fromUid({required String uid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return ChatUser.fromDocumentSnap(snap);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'username': username,
        'email': email,
        'image': image,
        'bio': bio,
        'friends': friends,
        'request': request,
        'created': created,
        'updated': updated
      };

  Future sendRequest(String userUid, String currentUser) {
    return FirebaseFirestore.instance.collection('users').doc(userUid).update({
      "request": FieldValue.arrayUnion([currentUser])
    });
  }

  Future acceptRequest(String userUid, String currentUser) {
    declineRequest(userUid, currentUser);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .update({
      "friends": FieldValue.arrayUnion([userUid])
    });
  }

  Future declineRequest(String userUid, String currentUser) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .update({
      "request": FieldValue.arrayRemove([userUid])
    });
  }

  Future deleteFriend(String userUid, String currentUser) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .update({
      "friend": FieldValue.arrayRemove([userUid])
    });
  }

  Future addBio(String userBio) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"bio": userBio});
  }

  Future sendMessageTest(
      {required String message, required String receiptUser}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(receiptUser)
        .collection('messages')
        .add(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);
  }

  Future createThread({required String toUser, required String currentUser}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(toUser)
        .collection('chats')
        .doc(currentUser)
        .set({'id': toUser});
  }

  static Stream<ChatUser> fromUidStream({required String uid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(ChatUser.fromDocumentSnap);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fromUidStreamChats(
      {required String uid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('chats')
        .snapshots();
  }

  static List<ChatUser> fromQuerySnap(QuerySnapshot snap) {
    try {
      return snap.docs.map(ChatUser.fromDocumentSnap).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Stream<List<ChatUser>> appUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map(ChatUser.fromQuerySnap);
  }

  static Stream<List<ChatUser>> currentThreads() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .map(ChatUser.fromQuerySnap);
  }
}
