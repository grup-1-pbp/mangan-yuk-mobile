class Profile {
  final String name;
  final String role;
  final String profileImage;

  Profile({
    required this.name,
    required this.role,
    required this.profileImage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    print("Parsing JSON: $json"); // Debug JSON yang diterima
    return Profile(
      name: json['name'] ?? 'Unknown', // Ambil properti 'name'
      role: json['role'] ?? 'Unknown', // Ambil properti 'role'
      profileImage: json['profile_image'] ?? '', // Ambil properti 'profile_image'
    );
  }
}
