import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/Page/EditProductPage.dart';
import 'dart:math';
import 'package:natthawut_flutter_049/Widget/customCliper.dart';
import 'package:natthawut_flutter_049/controllers/auth_controller.dart';
import 'package:natthawut_flutter_049/models/user_model.dart';
import 'package:natthawut_flutter_049/providers/user_provider.dart';
import 'package:natthawut_flutter_049/models/product_model.dart';
import 'package:natthawut_flutter_049/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .onLogout(); // เรียกฟังก์ชัน logout จาก controller

                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final productList = await ProductController().getProducts(context);
      setState(() {
        products = productList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching products: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $error')));
    }
  }

  // ฟังก์ชันสำหรับการแก้ไขสินค้า
  void updateProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  Future<void> deleteProduct(ProductModel product) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // แสดงกล่องยืนยันก่อนทำการลบ
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false); // ปิดกล่องและส่งค่ากลับ false
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true); // ปิดกล่องและส่งค่ากลับ true
              },
            ),
          ],
        );
      },
    );

    // ถ้าผู้ใช้ยืนยันการลบ
    if (confirmDelete == true) {
      try {
        await ProductController().deleteProduct(context, product.id);
        // เรียกใช้งาน _fetchProducts เพื่อดึงข้อมูลสินค้าใหม่
        await _fetchProducts();

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 255, 236),
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .1,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: [
                    //       Color(0xff0072ff), // Light Blue
                    //       Color(0xff00c6ff), // Dark Blue
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
            Padding(
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
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(158, 63, 192, 12)),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 119, 44), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, _) {
                        return Column(
                          children: [
                            _buildTokenInfo('Access Token:',
                                userProvider.accessToken, Color(0xff821131)),
                            _buildTokenInfo('Refresh Token:',
                                userProvider.refreshToken, Color(0xffFABC3F)),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                AuthController().refreshToken(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 4, 82, 30),
                              ),
                              child: Text('Update Token',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_product');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 17, 68, 47),
                      ),
                      child: Text('เพิ่มสินค้าใหม่',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!, style: TextStyle(color: Colors.red))
                    else
                      _buildProductList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(Icons.logout, color: Color(0xff821131), size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenInfo(String title, String? token, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(
          token ?? 'N/A',
          style: TextStyle(fontSize: 16, color: color),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.productName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffC7253E))),
                    SizedBox(height: 5),
                    Text('ประเภท: ${product.productType}',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffE85C0D))),
                    Text('ราคา: \$${product.price}',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff821131))),
                    Text('หน่วย: ${product.unit}',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffFABC3F))),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xffFABC3F)),
                onPressed: () {
                  updateProduct(product);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Color(0xff821131)),
                onPressed: () {
                  deleteProduct(product);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
