import 'package:flutter/material.dart';
import 'dart:math';
import 'package:natthawut_flutter_049/Widget/customCliper.dart'; // Assuming you already have customClipper
import 'package:natthawut_flutter_049/controllers/product_controller.dart';
import 'package:natthawut_flutter_049/models/product_model.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product; // Receive ProductModel to edit

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String productName;
  late String productType;
  late double price;
  late String unit;

  @override
  void initState() {
    super.initState();
    // Get data from ProductModel to display in the form
    productName = widget.product.productName;
    productType = widget.product.productType;
    price = widget.product.price.toDouble(); // Convert int to double
    unit = widget.product.unit;
  }

  // Function to update the product
  Future<void> _updateProduct(BuildContext context, String productId) async {
    final productController = ProductController();
    try {
      await productController.updateProduct(
        context,
        productId,
        productName,
        productType,
        price,
        unit,
      );
      // If the update is successful, navigate back to the previous screen
      Navigator.pushReplacementNamed(context, '/admin');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully')),
      );
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE0F2E9), Color(0xffA5D6A7)], // Green gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                    //     colors: [
                    //       Color(0xffA5D6A7),
                    //       Color(0xff388E3C),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'แก้ไข',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff4A7C0E), // Dark green color
                        ),
                        children: [
                          TextSpan(
                            text: ' ข้อมูลสินค้า',
                            style: TextStyle(
                                color: Color(0xff1B5E20), fontSize: 35), // Darker green color
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField(
                            label: 'ชื่อสินค้า',
                            initialValue: productName,
                            onSaved: (value) => productName = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ประเภทสินค้า',
                            initialValue: productType,
                            onSaved: (value) => productType = value!,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ราคา',
                            initialValue: price.toString(),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => price = double.parse(value!),
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'หน่วย',
                            initialValue: unit,
                            onSaved: (value) => unit = value!,
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // Call the update function
                                    _updateProduct(context, widget.product.id);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff4CAF50), // Green color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'แก้ไข',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/admin'); // Navigate to the product display page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(103, 103, 103, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create TextField for the product edit form
  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54), // Label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green), // Border color
        ),
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      onSaved: onSaved,
    );
  }
}
