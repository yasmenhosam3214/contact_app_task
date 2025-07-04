import 'dart:io';

class Contact {
  final String name;
  final String email;
  final String phone;
  final File image;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });
}
