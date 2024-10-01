import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<Map<String, dynamic>> _products = []; // Initialize _products
  bool _isLoading = true; // Initialize loading state
  final String _apiUrl = 'http://10.0.2.2:3000/api/products'; // Define your API URL here

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl)); // Fetch products from API

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _products = List<Map<String, dynamic>>.from(data);
        });
      } else {
        _handleError('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error fetching products: $e');
    } finally {
      // Set _isLoading to false regardless of the outcome
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      final response = await http.delete(Uri.parse('$_apiUrl/$productId'));
      if (response.statusCode == 200) {
        setState(() {
          _products.removeWhere((product) => product['id'].toString() == productId);
        });
      } else {
        _handleError('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error deleting product: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      _isLoading = false;
    });
    _showErrorDialog(message);
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.popAndPushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        color: const Color(0xFFA2D5AB),
        child: Stack(
          children: [
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFA2D5AB),
                          const Color(0xFF2F5233),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'จัดการ',
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2F5233),
                        ),
                        children: [
                          const TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(color: Colors.black, fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_product');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F5233),
                      ),
                      child: const Text(
                        'เพิ่มสินค้าใหม่',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_products.isEmpty)
                      const Center(
                        child: Text(
                          'ไม่มีสินค้าสำหรับแสดง',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE5E5E5),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _products[index]['product_name'] ?? 'Unknown Product',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2F5233),
                                        ),
                                      ),
                                      Text(
                                        'ประเภท: ${_products[index]['product_type'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'ราคา: \$${_products[index]['price'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'หน่วย: ${_products[index]['unit'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'สร้างเมื่อ: ${_products[index]['createdAt'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'แก้ไขล่าสุด: ${_products[index]['updatedAt'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF2F5233),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit_product',
                                      arguments: _products[index],
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context,
                                        _products[index]['id'].toString());
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFF2F5233),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ลบสินค้า'),
              onPressed: () async {
                await _deleteProduct(productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
