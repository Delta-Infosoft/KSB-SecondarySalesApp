String? nonEmptyValidator(String? val,String message){
  if(val==null || val.isEmpty){
    return message;
  }
  return null;
}

String? validateMobileNumber(String? value) {
  String pattern = r'^\d{10}$';
  RegExp regex = RegExp(pattern);
  if (value == null ||!regex.hasMatch(value)) {
    return 'Enter a valid mobile number';
  } else {
    return null;
  }
}

lengthValidator(String? val,int length,String emptyTitle,String message){
  if(val==null||val.isEmpty){
    return emptyTitle;
  }else if(val.trim().length<length){
    return message;
  }
  return null;
}

String? validateEmail(String? value) {
  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
  RegExp regex = RegExp(pattern);
  if (value == null ||!regex.hasMatch(value)) {
  return 'Enter a valid email address';
  } else {
  return null;
  }
}
