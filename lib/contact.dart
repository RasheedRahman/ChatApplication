class Contact {
  String name;
  String phoneNumber;
  String email;
  String birthday;
  String address;
  String image;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.birthday,
    required this.address,
    required this.image,
  });

  // Convert a Contact into a Map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'birthday': birthday,
      'address': address,
      'image': image,
    };
  }

  // Create a Contact from a Map (JSON format)
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      birthday: json['birthday'],
      address: json['address'],
      image: json['image'],
    );
  }

  // Override toString to print useful information
  @override
  String toString() {
    return 'Contact(name: $name, phoneNumber: $phoneNumber, email: $email)';
  }
}
