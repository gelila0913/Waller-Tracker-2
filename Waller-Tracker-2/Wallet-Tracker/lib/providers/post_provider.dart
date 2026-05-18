import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

enum PostStatus { initial, loading, loaded, error }

class PostProvider extends ChangeNotifier {
  final PostService _service;

  PostProvider({PostService? service}) : _service = service ?? PostService();

  List<Post> _posts = [];
  PostStatus _status = PostStatus.initial;
  String? _errorMessage;

  List<Post> get posts => _posts;
  PostStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> loadPosts() async {
    _status = PostStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await _service.fetchPosts();
      _status = PostStatus.loaded;
    } catch (error) {
      _errorMessage = _parseError(error);
      _status = PostStatus.error;
    }

    notifyListeners();
  }

  Future<void> addPost({required String title, required String body}) async {
    _status = PostStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final newPost = await _service.createPost(title: title, body: body);
      _posts.insert(0, newPost);
      _status = PostStatus.loaded;
    } catch (error) {
      _errorMessage = _parseError(error);
      _status = PostStatus.error;
    }

    notifyListeners();
  }

  Future<void> updatePost({required Post post}) async {
    _status = PostStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedPost = await _service.updatePost(post);
      final index = _posts.indexWhere((item) => item.id == post.id);
      if (index >= 0) {
        _posts[index] = updatedPost;
      }
      _status = PostStatus.loaded;
    } catch (error) {
      _errorMessage = _parseError(error);
      _status = PostStatus.error;
    }

    notifyListeners();
  }

  Future<void> deletePost(int id) async {
    _status = PostStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deletePost(id);
      _posts.removeWhere((post) => post.id == id);
      _status = PostStatus.loaded;
    } catch (error) {
      _errorMessage = _parseError(error);
      _status = PostStatus.error;
    }

    notifyListeners();
  }

  String _parseError(Object error) {
    if (error is Exception) {
      return error.toString();
    }
    return 'Unexpected error occurred';
  }
}
