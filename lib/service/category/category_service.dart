import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/model/category.dart';

class CategoryService {
  static const String baseUrl = 'https://martizoom.com';
  static const Map<String, String> headers = {
    'Authorization':
        'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbWFydGl6b29tLmNvbS9hcGkvYXV0aC9Mb2dpbiIsImlhdCI6MTY2MjkwMDIyMiwibmJmIjoxNjYyOTAwMjIyLCJqdGkiOiJBWEE3eUNmSnVyRjFjS2ZaIiwic3ViIjoxOTksInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.n9nvh4Dl_NApVXomUdr4EXB2zbERux_j_RUgl38SVj4',
    'Content-Type': 'application/json',
  };

  Future<List<Category>> fetchCategories(int marketId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/ListMarketsCategories/$marketId'),
      headers: headers,
    );
    return _processResponse(response, (data) => Category.fromJson(data));
  }

  List<T> _processResponse<T>(
      http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List dataJson = jsonResponse['data'];
        return dataJson.map((data) => fromJson(data)).toList();
      } else {
        throw Exception('Key "data" not found in response');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
