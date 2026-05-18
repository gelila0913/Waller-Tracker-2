import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  PostService([http.Client? client]) : _client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    final response = await _client.get(Uri.parse('$_baseUrl/posts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => Post.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw HttpException('Failed to load posts', response.statusCode);
  }

  Future<Post> createPost({required String title, required String body}) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': title, 'body': body, 'userId': 1}),
    );
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw HttpException('Failed to create post', response.statusCode);
  }

  Future<Post> updatePost(Post post) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/posts/${post.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw HttpException('Failed to update post', response.statusCode);
  }

  Future<void> deletePost(int id) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw HttpException('Failed to delete post', response.statusCode);
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() => 'HttpException($statusCode): $message';
}
