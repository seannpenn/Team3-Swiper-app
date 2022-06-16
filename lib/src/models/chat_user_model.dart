import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid, username, email, image;
  List<String> friends, request;
  Timestamp created, updated;

  ChatUser(
      {required this.uid,
      required this.username,
      required this.email,
      required this.image,
      this.friends = const[],
      this.request = const[],
      created,
      updated}): created = created ?? Timestamp.now(), updated = updated ?? Timestamp.now();

  static ChatUser fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatUser(
      uid: snap.id,
      friends: json['friends'] != null? List<String>.from(json['friends'])
      : <String>[],
      request: json['request'] != null? List<String>.from(json['request'])
      : <String>[],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? " ",
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

  static Stream<ChatUser> fromUidStream({required String uid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(ChatUser.fromDocumentSnap);
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
}
