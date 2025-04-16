class PostModel {
  String? username;
  String? email;
  String? uid;
  String? post;
  String? imageUrl;
  DateTime? timestamp;
  int likes ;
  List<String>? comments;

  PostModel({
    this.username,
    this.email,
    this.uid,
    this.post,
    this.imageUrl,
    this.timestamp,
    this.likes = 0,
    this.comments,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
      'post': post,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments ?? [],
    };
  }

  // Create PostModel from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      username: json['username'],
      email: json['email'],
      uid: json['uid'],
      post: json['post'],
      imageUrl: json['imageUrl'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
      likes: json['likes'] ,
      comments: List<String>.from(json['comments'] ?? []),
    );
  }

  // Getters & Setters
  String? get getUsername => username;
  set setUsername(String? value) => username = value;

  String? get getEmail => email;
  set setEmail(String? value) => email = value;

  String? get getUid => uid;
  set setUid(String? value) => uid = value;

  String? get getPost => post;
  set setPost(String? value) => post = value;

  String? get getImageUrl => imageUrl;
  set setImageUrl(String? value) => imageUrl = value;

  DateTime? get getTimestamp => timestamp;
  set setTimestamp(DateTime? value) => timestamp = value;

  int get getLikes => likes;
  set setLikes(int value) => likes = value;

  List<String>? get getComments => comments;
  set setComments(List<String>? value) => comments = value;
}
