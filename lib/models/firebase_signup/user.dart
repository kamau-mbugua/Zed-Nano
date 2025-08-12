class User {
  User({
    this.email,
    this.firstName,
    this.otherName,
    this.provider,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      otherName: json['otherName'] as String?,
      provider: json['provider'] as String?,
    );
  }

  final String? email;
  final String? firstName;
  final String? otherName;
  final String? provider;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'otherName': otherName,
      'provider': provider,
    };
  }

  @override
  String toString() {
    return 'User(email: $email, firstName: $firstName, otherName: $otherName, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.email == email &&
        other.firstName == firstName &&
        other.otherName == otherName &&
        other.provider == provider;
  }

  @override
  int get hashCode => Object.hash(email, firstName, otherName, provider);
}
