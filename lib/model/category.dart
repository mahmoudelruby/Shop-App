class Category {
  final String id;
  final String name;
  final String slug;
  final String image;
  final String imageTop;
  final String icon;
  final String theme;
  final String color;
  final int isPack;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.imageTop,
    required this.icon,
    required this.theme,
    required this.color,
    required this.isPack,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      image: json["image"],
      imageTop: json["image_top"],
      icon: json["icon"],
      theme: json["theme"],
      color: json["color"],
      isPack: 0,
    );
  }
}
