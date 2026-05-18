import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';
import 'post_form_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts();
    });
  }

  Future<void> _showPostForm({Post? post}) async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => PostFormScreen(post: post),
      ),
    );

    if (!mounted) return;
    if (result == null) return;

    final provider = context.read<PostProvider>();
    if (post != null) {
      final updatedPost = post.copyWith(
        title: result['title'],
        body: result['body'],
      );
      await provider.updatePost(post: updatedPost);
      if (provider.status == PostStatus.error) {
        _showError(provider.errorMessage);
      }
    } else {
      await provider.addPost(title: result['title']!, body: result['body']!);
      if (provider.status == PostStatus.error) {
        _showError(provider.errorMessage);
      }
    }
  }

  Future<void> _deletePost(Post post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (!mounted) return;
    if (confirmed != true) return;

    final provider = context.read<PostProvider>();
    await provider.deletePost(post.id);
    if (provider.status == PostStatus.error) {
      _showError(provider.errorMessage);
    }
  }

  void _showError(String? message) {
    if (message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder CRUD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostProvider>().loadPosts(),
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.status == PostStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == PostStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(provider.errorMessage ?? 'Unable to load posts.', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.loadPosts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.posts.isEmpty) {
            return const Center(child: Text('No posts available. Create one with the + button.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadPosts(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: provider.posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final post = provider.posts[index];
                return Card(
                  child: ListTile(
                    title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showPostForm(post: post),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deletePost(post),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostForm(),
        tooltip: 'Create a new post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
