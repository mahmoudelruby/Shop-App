import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/stand.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/service/category/category_provider.dart';
import 'package:shopping_app/service/product/product_provider.dart';
import 'package:shopping_app/service/stand/stand_provider.dart';
import 'package:shopping_app/view/category_page.dart';

class ProductScreen extends StatefulWidget {
  final int categoryId;

  ProductScreen({required this.categoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int? selectedCategoryId;
  int? selectedStandId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(2, selectedCategoryId!, 0, 0, 10);
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories(2);
    Provider.of<StandProvider>(context, listen: false)
        .fetchStands(2, selectedCategoryId!);
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(2, selectedCategoryId!, 0, 0, 10);
      Provider.of<StandProvider>(context, listen: false)
          .fetchStands(2, selectedCategoryId!);
    });
  }

  void _onStandSelected(int standId) {
    setState(() {
      selectedStandId = standId;
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(2, selectedCategoryId!, standId, 0, 10);
    });
  }

  void _navigateToAllCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(), // Navigate to CategoryScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              if (categoryProvider.isLoading) {
                return const LinearProgressIndicator();
              } else if (categoryProvider.errorMessage != null) {
                print(
                    'Error fetching categories: ${categoryProvider.errorMessage}');
                return Center(
                    child: Text('Error: ${categoryProvider.errorMessage}'));
              } else if (categoryProvider.categories.isEmpty) {
                return const Center(child: Text('No categories found'));
              } else {
                List<Category> categories = categoryProvider.categories;
                return Container(
                  height: 50,
                  color: Colors.red,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            Category category = categories[index];
                            bool isSelected =
                                category.id == selectedCategoryId.toString();
                            return GestureDetector(
                              onTap: () =>
                                  _onCategorySelected(int.parse(category.id)),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100.0,
                                    margin: const EdgeInsets.all(8),
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 100.0,
                                      height: 2.0,
                                      color: Colors.white,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: _navigateToAllCategories,
                          child: Container(
                            width: 100.0,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: const Icon(
                              Icons.category_sharp,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          Consumer<StandProvider>(
            builder: (context, standProvider, child) {
              if (standProvider.isLoading) {
                return const LinearProgressIndicator();
              } else if (standProvider.errorMessage != null) {
                print('Error fetching stands: ${standProvider.errorMessage}');
                return Center(
                    child: Text('Error: ${standProvider.errorMessage}'));
              } else if (standProvider.stands.isEmpty) {
                return const Center(child: Text('No stands found'));
              } else {
                List<Stand> stands = standProvider.stands;
                return Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stands.length,
                    itemBuilder: (context, index) {
                      Stand stand = stands[index];
                      bool isSelected = stand.id == selectedStandId;
                      return GestureDetector(
                        onTap: () => _onStandSelected(stand.id),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red, // Border color
                                  width: .5, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    15.0), // Optional: Border radius
                              ),
                              width: 100.0,
                              margin: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  stand.title,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 50.0,
                                height: 2.0,
                                color: Colors.red,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productProvider.errorMessage != null) {
                  print(
                      'Error fetching products: ${productProvider.errorMessage}');
                  return Center(
                      child: Text('Error: ${productProvider.errorMessage}'));
                } else if (productProvider.products.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  List<Product> products = productProvider.products;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${product.price} EGP',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle availability button press if needed
                                },
                                child: Text(
                                  product.isOutOfStock
                                      ? 'Out of Stock'
                                      : 'Add to Cart',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: product.isOutOfStock
                                      ? Colors.blueGrey
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
