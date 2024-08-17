class UserModel{
  final String id;
  final String name;
  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String,dynamic> data){
    return UserModel(id: data['id'], name: data['name']);
  }
}