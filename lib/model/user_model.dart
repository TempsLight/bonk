class User {
  final int? id;
  final String? name;
  final String? email;
  final int? age;
  final String? balance;
  final String? token;
  final String? phone_number;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.balance,
    this.token,
    this.phone_number
  });

  factory User.fromJson(Map<String, dynamic> json){
    
    return User(
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        age: json['user']['age'],
        balance: json['user']['balance'],
        token: json['token'],
        phone_number: json['user']['phone_number']
    );
  }
}