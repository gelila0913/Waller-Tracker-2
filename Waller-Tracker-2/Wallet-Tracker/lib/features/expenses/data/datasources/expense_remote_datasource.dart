import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses();
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final http.Client _client;
  final Uri _baseUri;

  ExpenseRemoteDataSourceImpl({
    http.Client? client,
    String baseUrl = 'https://dummyjson.com',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final response = await _client.get(_uri('/products', {'limit': '20'}));
    final data = _decodeResponse(response);
    final products = (data['products'] as List).cast<Map<String, dynamic>>();
    return products.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    final response = await _client.post(
      _uri('/products/add'),
      headers: _jsonHeaders,
      body: jsonEncode(expense.toJson()),
    );
    return ExpenseModel.fromJson(_decodeResponse(response));
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final response = await _client.put(
      _uri('/products/${expense.id}'),
      headers: _jsonHeaders,
      body: jsonEncode(expense.toJson()),
    );
    return ExpenseModel.fromJson(_decodeResponse(response));
  }

  @override
  Future<void> deleteExpense(String id) async {
    final response = await _client.delete(_uri('/products/$id'));
    _decodeResponse(response);
  }

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    return _baseUri.replace(path: path, queryParameters: queryParameters);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
