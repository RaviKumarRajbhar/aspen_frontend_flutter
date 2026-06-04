class FollowModel {

  final String username;
  final String id;
  final String bio;

  FollowModel({required this.username, required this.id, required this.bio});

  factory FollowModel.fromJson(Map<String , dynamic>  json){
   return FollowModel(
     username : json["username"],
     id: json["id"],
     bio: json["bio"]
   );
  }
}