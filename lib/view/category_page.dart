import 'package:flutter/material.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/service/category/category_service.dart';
import 'package:shopping_app/view/product_page.dart';
// Import the ProductScreen

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService().fetchCategories(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          } else {
            List<Category> categories = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Category category = categories[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the ProductScreen when a category is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductScreen(categoryId: int.parse(category.id)),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            category.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.name,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
