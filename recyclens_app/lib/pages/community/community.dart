import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recyclens_app/pages/community/add_post.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('community_post')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading posts"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                postId: post.id,
                username: post['username'],
                email: post['email'],
                postText: post['post'],
                imageUrl: post['imageUrl'],
                timestamp: post['timestamp'],
                likes: post['likes'],
                comments: List<String>.from(post['comments']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddPostPage()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final String postId;
  final String username;
  final String email;
  final String postText;
  final String imageUrl;
  final Timestamp timestamp;
  final int likes;
  final List<String> comments;

  const PostCard({
    super.key,
    required this.postId,
    required this.username,
    required this.email,
    required this.postText,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;

  void _toggleLike() async {
    final postRef = FirebaseFirestore.instance.collection('community_post').doc(widget.postId);

    setState(() {
      isLiked = !isLiked;
    });

    await postRef.update({
      'likes': FieldValue.increment(isLiked ? 1 : -1),
    });
  }

  void _showComments() {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.comments.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.comment, color: Colors.green),
                    title: Text(widget.comments[index]),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (commentController.text.trim().isNotEmpty) {
                          final updatedComments = [...widget.comments, commentController.text.trim()];
                          await FirebaseFirestore.instance
                              .collection('community_post')
                              .doc(widget.postId)
                              .update({'comments': updatedComments});
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('dd MMM, hh:mm a').format(widget.timestamp.toDate());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3'), // optional default avatar
                  radius: 22,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          if (widget.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(widget.postText, style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                Text('${widget.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _showComments,
                  icon: const Icon(Icons.comment_outlined),
                ),
                Text('${widget.comments.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
