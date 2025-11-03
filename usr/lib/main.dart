import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoveLink Global',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF4B91),
        scaffoldBackgroundColor: const Color(0xFFFFF5F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF4B91),
          primary: const Color(0xFFFF4B91),
          secondary: const Color(0xFFFF4B91),
          background: const Color(0xFFFFF5F8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF4B91),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const LoveLinkHomeScreen(),
    );
  }
}

// --- Data Models ---
class User {
  final String username;
  final String profilePhotoUrl;
  final bool isOnline;

  User({
    required this.username,
    required this.profilePhotoUrl,
    this.isOnline = false,
  });
}

class Comment {
  final User user;
  final String text;

  Comment({
    required this.user,
    required this.text,
  });
}

class Post {
  final String id;
  final User user;
  final String content;
  final String? imageUrl;
  int likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.user,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    required this.comments,
  });
}

// --- Home Screen ---
class LoveLinkHomeScreen extends StatefulWidget {
  const LoveLinkHomeScreen({super.key});

  @override
  State<LoveLinkHomeScreen> createState() => _LoveLinkHomeScreenState();
}

class _LoveLinkHomeScreenState extends State<LoveLinkHomeScreen> {
  // --- Mock Data ---
  final User currentUser = User(
    username: "You",
    profilePhotoUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    isOnline: true,
  );

  late final List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _generateMockPosts();
  }

  List<Post> _generateMockPosts() {
    final User user1 = User(
        username: "Alice",
        profilePhotoUrl: "https://randomuser.me/api/portraits/women/1.jpg",
        isOnline: true);
    final User user2 = User(
        username: "Bob",
        profilePhotoUrl: "https://randomuser.me/api/portraits/men/1.jpg",
        isOnline: false);
    final User user3 = User(
        username: "Charlie",
        profilePhotoUrl: "https://randomuser.me/api/portraits/men/2.jpg",
        isOnline: true);

    return [
      Post(
        id: '1',
        user: user1,
        content: "Enjoying a beautiful day out in the park! 🌳☀️",
        imageUrl: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
        likes: 128,
        comments: [
          Comment(user: user2, text: "Looks amazing!"),
          Comment(user: user3, text: "I wish I was there!"),
        ],
      ),
      Post(
        id: '2',
        user: user2,
        content: "Just tried this new recipe for pasta, and it's delicious! 🍝",
        likes: 76,
        comments: [
          Comment(user: user1, text: "You should share the recipe!"),
        ],
      ),
      Post(
        id: '3',
        user: user3,
        content: "My new painting is finally complete. What do you guys think?",
        imageUrl: "https://images.unsplash.com/photo-1501472312651-726afe119ff1",
        likes: 210,
        comments: [],
      ),
    ];
  }

  void _addPost(String content) {
    if (content.isEmpty) return;
    setState(() {
      _posts.insert(
        0,
        Post(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          user: currentUser,
          content: content,
          likes: 0,
          comments: [],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💞 LoveLink Global"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _posts.length + 1, // +1 for the post creation form
        itemBuilder: (context, index) {
          if (index == 0) {
            return PostCreationCard(onPost: _addPost);
          }
          final post = _posts[index - 1];
          return PostCard(post: post);
        },
      ),
    );
  }
}

// --- Widgets ---

class PostCreationCard extends StatefulWidget {
  final Function(String) onPost;

  const PostCreationCard({super.key, required this.onPost});

  @override
  State<PostCreationCard> createState() => _PostCreationCardState();
}

class _PostCreationCardState extends State<PostCreationCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Share your thoughts globally...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement image picking
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Add Image"),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onPost(_controller.text);
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Post", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _showComments = false;

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        widget.post.likes--;
      } else {
        widget.post.likes++;
      }
      _isLiked = !_isLiked;
    });
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(),
            const SizedBox(height: 10),
            Text(widget.post.content, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            if (widget.post.imageUrl != null) _buildPostImage(),
            const SizedBox(height: 10),
            _buildPostActions(),
            if (_showComments) CommentSection(comments: widget.post.comments),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(widget.post.user.profilePhotoUrl),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.post.user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (widget.post.user.isOnline) ...[
                  const SizedBox(width: 5),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPostImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.post.imageUrl!,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPostActions() {
    return Row(
      children: [
        InkWell(
          onTap: _toggleLike,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _isLiked ? '❤️ ' : '🤍 ',
                  style: const TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.post.likes} Likes',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        InkWell(
          onTap: _toggleComments,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '💬 ',
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.post.comments.length} Comments',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CommentSection extends StatefulWidget {
  final List<Comment> comments;

  const CommentSection({super.key, required this.comments});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          ...widget.comments.map((c) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(c.user.profilePhotoUrl),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: '${c.user.username}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: c.text),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement adding a comment
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Post"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
