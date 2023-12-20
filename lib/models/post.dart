class Post {
  final String postId;
  final String caption;
  final String imageUrl;
  final String? trainerId;

  Post({
    required this.postId,
    required this.caption,
    required this.imageUrl,
    this.trainerId,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['id'],
      caption: map['caption'],
      imageUrl: map['imageUrl'],
      trainerId: map['trainerId'] ?? '',
    );
  }
}
