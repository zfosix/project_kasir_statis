import 'package:flutter/material.dart';
import 'checkout_page.dart';
import 'package:intl/intl.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final TextEditingController searchController = TextEditingController();

  // Daftar produk
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Makaroni',
      'category': 'Makanan',
      'price': 'Rp. 20.000',
      'image': 'assets/images/makanan.jpeg',
    },
    {
      'name': 'MilkShake',
      'category': 'Minuman',
      'price': 'Rp. 25.000',
      'image': 'assets/images/minuman.jpeg',
    },
    {
      'name': 'Ikan Bakar',
      'category': 'Makanan',
      'price': 'Rp. 220.000',
      'image': 'assets/images/ikanbakar.jpeg',
    },
    {
      'name': 'Seblak',
      'category': 'Makanan',
      'price': 'Rp. 45.000',
      'image': 'assets/images/seblak.jpeg',
    },
    {
      'name': 'Sop Buah',
      'category': 'Makanan',
      'price': 'Rp. 15.000',
      'image': 'assets/images/sopbuah.jpeg',
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> selectedProducts = [];
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) {
          final name = product['name']?.toLowerCase() ?? '';
          final category = product['category']?.toLowerCase() ?? '';
          return name.contains(query) || category.contains(query);
        }).toList();
      }
    });
  }

  void _updateTotalPrice() {
    int newTotalPrice = 0;
    for (var product in selectedProducts) {
      final priceStr =
          product['price']?.replaceAll('Rp. ', '').replaceAll('.', '') ?? '0';
      int productPrice = int.tryParse(priceStr) ?? 0;
      // Konversi hasil perkalian ke int
      newTotalPrice += (productPrice * (product['quantity'] ?? 1)).toInt();
    }
    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  void _toggleSelection(Map<String, dynamic> product) {
    setState(() {
      final existingProduct = selectedProducts
          .firstWhere((p) => p['name'] == product['name'], orElse: () => {});
      if (existingProduct.isNotEmpty) {
        selectedProducts.remove(existingProduct);
      } else {
        selectedProducts.add({...product, 'quantity': 1});
      }
      _updateTotalPrice();
    });
  }

  void _updateQuantity(Map<String, dynamic> product, bool isIncrement) {
    setState(() {
      final existingProduct = selectedProducts
          .firstWhere((p) => p['name'] == product['name'], orElse: () => {});

      if (existingProduct.isNotEmpty) {
        if (isIncrement) {
          existingProduct['quantity'] += 1;
        } else {
          existingProduct['quantity'] = (existingProduct['quantity'] > 1)
              ? existingProduct['quantity'] - 1
              : 1;
        }
      }
      _updateTotalPrice();
    });
  }

  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "id_ID");
    return "Total Harga : Rp ${formatter.format(price)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cashier App",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                ),
                const Text(
                  "Semoga harimu menyenangkan :)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Menampilkan daftar produk yang difilter
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final selected = selectedProducts
                          .any((p) => p['name'] == product['name']);
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: Image.asset(product['image'] ?? ''),
                          title: Text(product['name'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['category'] ?? ''),
                              Text(product['price'] ?? ''),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selected)
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _updateQuantity(product, false),
                                ),
                              if (selected)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${selectedProducts.firstWhere((p) => p['name'] == product['name'])['quantity']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              IconButton(
                                icon: Icon(
                                  selected ? Icons.add_circle : Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  if (selected) {
                                    _updateQuantity(product, true);
                                  } else {
                                    _toggleSelection(product);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tombol Checkout
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 55,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatPrice(totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_checkout_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              totalPrice: totalPrice,
                              selectedProducts: selectedProducts,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}