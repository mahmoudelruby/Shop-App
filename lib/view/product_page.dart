import 'package:flutter/material.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/stand.dart';
import 'package:shopping_app/service/category/category_service.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/service/product/product_service.dart';
import 'package:shopping_app/service/stand/stand_service.dart';
import 'package:shopping_app/view/category_page.dart';
// Import the CategoryScreen

class ProductScreen extends StatefulWidget {
  final int categoryId;

  ProductScreen({required this.categoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> futureProducts;
  late Future<List<Category>> futureCategories;
  late Future<List<Stand>> futureStands;
  int? selectedCategoryId;
  int? selectedStandId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;
    futureProducts =
        ProductService().fetchProducts(2, selectedCategoryId!, 0, 0, 10);
    futureCategories = CategoryService().fetchCategories(2);
    futureStands = StandService().fetchStands(2, selectedCategoryId!);
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      futureProducts =
          ProductService().fetchProducts(2, selectedCategoryId!, 0, 0, 10);
      futureStands = StandService().fetchStands(2, selectedCategoryId!);
    });
  }

  void _onStandSelected(int standId) {
    setState(() {
      selectedStandId = standId;
      futureProducts = ProductService()
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
          FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              } else if (snapshot.hasError) {
                print('Error fetching categories: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found'));
              } else {
                List<Category> categories = snapshot.data!;
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
          FutureBuilder<List<Stand>>(
            future: futureStands,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              } else if (snapshot.hasError) {
                print('Error fetching stands: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No stands found'));
              } else {
                List<Stand> stands = snapshot.data!;
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
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error fetching products: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  List<Product> products = snapshot.data!;
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
