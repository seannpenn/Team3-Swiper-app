import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageService {
  static updateProfileImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileRef = storageRef.child(
            'profiles/${FirebaseAuth.instance.currentUser!.uid}/${image.path.split('/').last}');
        print(profileRef.fullPath);
        File file = File(image.path);
        print(image.path);
        TaskSnapshot result = await profileRef.putFile(file);
        String publicUrl = await profileRef.getDownloadURL();
        print(publicUrl);
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'image': publicUrl});
      } else {}
    } catch (e) {
      print(e);
    }
  }
}