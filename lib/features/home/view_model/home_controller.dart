import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/dummy_user_data_model.dart';
import '../repositorys/home_repository.dart';

class HomeController extends GetxController {
  RxInt selectedTypeIndex = 0.obs;
  RxString selectedFilePath = ''.obs;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  RxBool isSubmitting = false.obs;
  RxBool isRecordLolading = false.obs;
  List recordsList = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<String> pickImage() async {
    XFile? pickImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    return pickImage?.path ?? '';
    //pickImage? means that the pickiamge variable is nullable
    // this is short syntax of this
    // if(pickImage != null{
    // return pickImage!.path;
    // }else{
    // return '';
    //}
  }

  clearForm(){
    nameCtrl.clear();
    emailCtrl.clear();
    mobileCtrl.clear();
    selectedFilePath.value='';
  }

  getRecords() async {
    isRecordLolading.value=true;
    recordsList  = await HomeRepository.getRecordsList();
    isRecordLolading.value=false;
  }

  onSubmitData() async {
    if(formKey.currentState!.validate()){
      if(selectedFilePath.value.isEmpty){
        Fluttertoast.showToast(msg: 'Please select image');
        return;
      }
      isSubmitting.value=true;
      final isDataInserted = await HomeRepository.insertDataToServer(DummyUserDataModel(uid: DateTime.now().toIso8601String(), name: nameCtrl.text, email: emailCtrl.text, mobileNo: mobileCtrl.text, localImagePath: selectedFilePath.value));
      if(isDataInserted){
        Fluttertoast.showToast(msg: 'Data inserted successfully',gravity: ToastGravity.CENTER);
        selectedTypeIndex.value=1;
        clearForm();
        getRecords();
      }else{
        Fluttertoast.showToast(msg: 'Opps something went wrong please try again...',gravity: ToastGravity.CENTER);
      }

      isSubmitting.value=false;

    }
  }
}
