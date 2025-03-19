import 'dart:convert';


class User {
 final String name;
 final String? image;
    User({
    required this.name,
    this.image
  });

    User copyWith({
    String? name,
    String? image    
  }) {
    return User(
          name: name ?? this.name,
      image: image ?? this.image
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
