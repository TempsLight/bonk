class User {
  final int? id;
  String? name;
  String? email;
  int? age;
  String? balance;
  String? token;
  String? phone_number;

  User({
    required this.id,
    this.name,
    this.email,
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