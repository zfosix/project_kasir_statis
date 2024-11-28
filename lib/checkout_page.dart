import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatelessWidget {
  final int totalPrice;
  final List<Map<String, dynamic>> selectedProducts;

  CheckoutPage({super.key, required this.totalPrice, required this.selectedProducts});

  String formatPrice(int price) {
    final formatter = NumberFormat("#,###", "id_ID");
    return "Total Harga : Rp ${formatter.format(price)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.grey[800], // Mengganti warna app bar menjadi abu-abu
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total price section with custom style
            Text(
              formatPrice(totalPrice),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Mengubah warna harga menjadi hitam
              ),
            ),
            const SizedBox(height: 20),

            // List of selected products in cards
            Expanded(
              child: ListView.builder(
                itemCount: selectedProducts.length,
                itemBuilder: (context, index) {
                  final product = selectedProducts[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.grey[200],  // Card menggunakan warna abu-abu muda
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Colors.grey[700],  // Ikon dengan warna abu-abu gelap
                        size: 30,
                      ),
                      title: Text(
                        product['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,  // Judul produk tetap hitam
                        ),
                      ),
                      subtitle: Text('Qty: ${product['quantity']}'),
                      trailing: Text(
                        'Rp ${product['quantity'] * int.parse(product['price'].replaceAll('Rp. ', '').replaceAll('.', ''))}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,  // Harga produk tetap hitam
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Payment button with attractive style in grey theme
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text(
                          'Pembayaran Berhasil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'Terima kasih atas pembelian Anda!',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Tutup dialog
                              Navigator.pop(context, true); // Kembali ke halaman CashierPage
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.grey),  // Warna teks tombol OK
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],  // Tombol dengan warna abu-abu gelap
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Lakukan Pembayaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,  // Warna teks putih
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
