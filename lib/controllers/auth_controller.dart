import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Login method can be added here

  Future<UserCredential?> signupMethod({required String email, required String password, required String name, required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await storeUserData(name: name, password: password, email: email);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  Future<void> storeUserData({required String name, required String password, required String email}) async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      DocumentReference store = firestore.collection('users').doc(currentUser.uid);
      await store.set({
        'name': name,
        'password': password,
        'email': email,
        'imgUrl': ''
      });
    }
  }
}

signoutMethod(context) async{
  try{
    await auth.signOut();
  }catch (e) {
    VxToast.show(context, msg: e.toString());
  }
}