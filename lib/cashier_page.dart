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

  // Daftar produk dengan tambahan stok
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Makaroni',
      'category': 'Makanan',
      'price': 'Rp. 20.000',
      'image': 'assets/images/makanan.jpeg',
      'quantity': 0,
      'stock': 20,
    },
    {
      'name': 'MilkShake',
      'category': 'Minuman',
      'price': 'Rp. 25.000',
      'image': 'assets/images/minuman.jpeg',
      'quantity': 0,
      'stock': 15,
    },
    {
      'name': 'Ikan Bakar',
      'category': 'Makanan',
      'price': 'Rp. 220.000',
      'image': 'assets/images/ikanbakar.jpeg',
      'quantity': 0,
      'stock': 10,
    },
    {
      'name': 'Seblak',
      'category': 'Makanan',
      'price': 'Rp. 45.000',
      'image': 'assets/images/seblak.jpeg',
      'quantity': 0,
      'stock': 25,
    },
    {
      'name': 'Sop Buah',
      'category': 'Makanan',
      'price': 'Rp. 15.000',
      'image': 'assets/images/sopbuah.jpeg',
      'quantity': 0,
      'stock': 30,
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
    selectedProducts = products.where((product) => product['quantity'] > 0).toList();

    for (var product in selectedProducts) {
      final priceStr =
          product['price']?.replaceAll('Rp. ', '').replaceAll('.', '') ?? '0';
      int productPrice = int.tryParse(priceStr) ?? 0;
      newTotalPrice += (productPrice * product['quantity']).toInt();
    }

    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  void _updateQuantity(Map<String, dynamic> product, bool isIncrement) {
    setState(() {
      if (isIncrement) {
        if (product['stock'] > 0) {
          product['quantity'] += 1;
          product['stock'] -= 1;
        } else {
          _showStockEmptyAlert(product); // Tampilkan alert jika stok habis
        }
      } else {
        if (product['quantity'] > 0) {
          product['quantity'] -= 1;
          product['stock'] += 1;
        }
      }
      _updateTotalPrice();
    });
  }

  void _resetProductQuantities() {
    setState(() {
      for (var product in products) {
        if (product['quantity'] > 0) {
          product['quantity'] = 0; // Reset kuantitas menjadi 0
        }
      }
      totalPrice = 0; // Reset total harga
    });
  }

  void _showStockEmptyAlert(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Stok Habis'),
          content: Text('Maaf, stok ${product['name']} sudah habis.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
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
                              Text('Stok: ${product['stock']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: product['quantity'] > 0
                                    ? () => _updateQuantity(product, false)
                                    : null,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${product['quantity']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: product['stock'] > 0
                                    ? () => _updateQuantity(product, true)
                                    : () {
                                        _showStockEmptyAlert(product); // Tampilkan alert ketika stok 0
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
                      onPressed: totalPrice > 0
                          ? () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    totalPrice: totalPrice,
                                    selectedProducts: selectedProducts,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _resetProductQuantities();
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
