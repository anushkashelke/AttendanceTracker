import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

class StoreImage{
  final FirebaseStorage _storage= FirebaseStorage.instance;
  final FirebaseAuth userid=FirebaseAuth.instance;

  Future<String> UploadImageToStorage(String childName,String StudentId,File UploadFile) async{
    Reference ref_path= _storage.ref().child(childName).child(StudentId);  //creating folder of child name
    //                   Post folder                  Uid Folder of each user
    UploadTask uploadTask =ref_path.putFile(UploadFile);  //this provides ua a way on how our file will be uploaded on firebase
    TaskSnapshot snap= await uploadTask;
    String DownloadUrl = await snap.ref.getDownloadURL() ;  //url of the path where file will be stored
    return DownloadUrl;
  }
}