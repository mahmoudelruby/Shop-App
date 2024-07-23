import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/service/category/category_provider.dart';

import 'package:shopping_app/view/product_page.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (categoryProvider.errorMessage != null) {
            return Center(
                child: Text('Error: ${categoryProvider.errorMessage}'));
          } else if (categoryProvider.categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          } else {
            List<Category> categories = categoryProvider.categories;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Category category = categories[index];
                return GestureDetector(
                  onTap: () {
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
