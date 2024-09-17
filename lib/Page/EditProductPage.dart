import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart'; // Assuming you already have customClipper

class EditProductPage extends StatefulWidget {
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController productNameController;
  late TextEditingController productTypeController;
  late TextEditingController priceController;
  late TextEditingController unitController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with default values
    productNameController = TextEditingController(text: 'คอมพิวเตอร์');
    productTypeController = TextEditingController(text: 'เครื่องใช้ไฟฟ้า');
    priceController = TextEditingController(text: '800');
    unitController = TextEditingController(text: 'บาท');
  }

  @override
  void dispose() {
    // Dispose of controllers when the screen is disposed
    productNameController.dispose();
    productTypeController.dispose();
    priceController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE9EFEC),
                          Color(0xffFABC3F),
                        ],
                      ),
                    ),
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
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
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
                            controller: productNameController,
                            label: 'ชื่อสินค้า',
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: productTypeController,
                            label: 'ประเภทสินค้า',
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: priceController,
                            label: 'ราคา',
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: unitController,
                            label: 'หน่วย',
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Save the updated product data
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff821131),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Text(
                                'บันทึกการแก้ไข',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        onSaved: (value) {
          controller.text = value!;
        },
      ),
    );
  }
}
