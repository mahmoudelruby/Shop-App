import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/model/stand.dart';
import 'package:shopping_app/model/product.dart';

class StandService {
  static const String baseUrl = 'https://martizoom.com';
  static const Map<String, String> headers = {
    'Authorization':
        'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbWFydGl6b29tLmNvbS9hcGkvYXV0aC9Mb2dpbiIsImlhdCI6MTY2MjkwMDIyMiwibmJmIjoxNjYyOTAwMjIyLCJqdGkiOiJBWEE3eUNmSnVyRjFjS2ZaIiwic3ViIjoxOTksInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.n9nvh4Dl_NApVXomUdr4EXB2zbERux_j_RUgl38SVj4',
    'Content-Type': 'application/json',
  };

  Future<List<Stand>> fetchStands(int marketId, int categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Category/stands/$marketId/$categoryId'),
      headers: headers,
    );
    return _processResponse(response, (data) => Stand.fromJson(data));
  }

  Future<List<Product>> fetchProductsByStand(int standId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Stand/products/$standId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List dataJson = jsonResponse['data'];
        return dataJson.map((data) => Product.fromJson(data)).toList();
      } else {
        print('Key "data" not found in response: ${response.body}');
        throw Exception('Key "data" not found in response');
      }
    } else {
      print('Failed to load data: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load data');
    }
  }

  List<T> _processResponse<T>(
      http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List dataJson = jsonResponse['data'];
        return dataJson.map((data) => fromJson(data)).toList();
      } else {
        print('Key "data" not found in response: ${response.body}');
        throw Exception('Key "data" not found in response');
      }
    } else {
      print('Failed to load data: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
