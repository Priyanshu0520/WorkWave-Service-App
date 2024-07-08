import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;



class Manpower {
  
  final String name;
  
  final String minSalary;
  final String maxSalary;
  final String ?currentLocation;
  final String category;
  Manpower({
   
    required this.name,
   
    required this.maxSalary,
    required this.minSalary,
    required this.currentLocation,
    required this.category
    
  });

  factory Manpower.fromJson(Map<String, dynamic> json) {
    return Manpower(
     
      name: json['name']??"",
      category :json['category']?['name']??"",
     
      
     // dob: json['dob']??"",
      
      maxSalary:  json['maxSalary']??"",
      minSalary: json['minSalary']??"",
      currentLocation:  json['serviceLocation']?['address'],
  
    );
  }
}
class AllManpower {
 Future<List<Manpower>> fetchManpowerData() async {
  final response = await http.get(Uri.parse('https://workwave-backend.vercel.app//api/v1/manpower'));

  if (response.statusCode == 200) {
    Iterable jsonResponse = json.decode(response.body)['data'];
    List<Manpower> manpowerList = jsonResponse.map((data) => Manpower.fromJson(data)).toList();
    
    // Shuffle the list
    final random = Random();
    manpowerList.shuffle(random);
    
    return manpowerList;
  } else {
    throw Exception('Failed to load manpower data');
  }
}
}