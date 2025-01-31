class User {
  final String id;
  final String username;
  final String role;
  final String name;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'name': name,
    };
  }
}
