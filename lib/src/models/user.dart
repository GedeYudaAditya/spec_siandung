class User {
  final int id;
  final String username;
  final String name;
  final int role;

  User(
      {required this.id,
      required this.username,
      required this.name,
      required this.role});

  // Method untuk mengonversi JSON ke model User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
    );
  }

  // Method untuk mengonversi model User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
    };
  }
}
