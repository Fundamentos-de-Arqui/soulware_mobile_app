class User {
  final int id;
  final String dni;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String typeOfUser;
  
  User({required this.id, required this.dni, required this.email, required this.fullName, required this.phoneNumber, required this.typeOfUser});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      dni: json['dni'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      typeOfUser: json['type_of_user'],
    );
  }
}