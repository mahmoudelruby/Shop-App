class Stand {
  final int id;
  final String title;
  final String imageUrl;
  final String file;

  Stand({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.file,
  });

  factory Stand.fromJson(Map<String, dynamic> json) {
    return Stand(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image2d'],
      file: json['file'],
    );
  }
}
