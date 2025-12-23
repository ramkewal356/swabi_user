// class Traveller {
//   final String name;
//   final String type;
//   final int age;
//   final String gender;
//   final double price;

//   Traveller({
//     required this.name,
//     required this.type,
//     required this.age,
//     required this.gender,
//     required this.price,
//   });

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "type": type,
//         "age": age,
//         "gender": gender,
//         "price": price,
//       };
// }
enum TravellerType { adult, senior, child, infant }

class Traveller {
  String name;
  int age;
  String gender;
  TravellerType type;
  double price;
  // List<int> activities;
  Traveller({
    required this.name,
    required this.age,
    required this.gender,
    required this.type,
    required this.price,
    // required this.activities
  });

  bool get isAdult => type == TravellerType.adult;
  // type == TravellerType.adult || type == TravellerType.senior;

  bool get isSenior => type == TravellerType.senior;
  String get ageUnit => 'Year';

  Map<String, dynamic> toPayloadJson() => {
        "name": name,
        "age": age,
        "gender": gender,
        "ageUnit": ageUnit,
        "price": price,
        // "activities": activities,
      };
}
