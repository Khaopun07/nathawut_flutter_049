import 'package:flutter/material.dart';
import 'dart:math';
import 'package:natthawut_flutter_049/Widget/customCliper.dart'; // Assuming you already have customClipper

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productType = '';
  int price = 0;
  String unit = '';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        color: Color(0xFFA2D5AB), // พื้นหลังสีเขียวหลัก
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
                          Color(0xFFA2D5AB), // สีเขียวหลัก
                          Color(0xFF2F5233), // สีเขียวเข้ม
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
                        text: 'เพิ่ม',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2F5233), // สีเขียวเข้ม
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้าใหม่',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                            ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกชื่อสินค้า';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productName = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ประเภทสินค้า',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกประเภทสินค้า';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productType = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ราคา',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกราคา';
                              }
                              if (int.tryParse(value) == null) {
                                return 'กรุณากรอกจำนวนเต็มที่ถูกต้อง';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = int.parse(value!);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'หน่วย',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกหน่วย';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              unit = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // บันทึกข้อมูลสินค้าใหม่
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2F5233), // สีเขียวเข้ม
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Text(
                                'บันทึก',
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
    required String label,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
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
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
