import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // สมมุติว่าคุณมีฟังก์ชัน fetchProducts ที่ดึงข้อมูลผลิตภัณฑ์จาก API
      _products = await fetchProducts();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    _products.remove(product);
    notifyListeners();
  }

  void updateProduct(ProductModel updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }
}

// สมมุติว่ามีฟังก์ชัน fetchProducts ที่จะทำการดึงข้อมูลผลิตภัณฑ์จาก API
Future<List<ProductModel>> fetchProducts() async {
  // ทำการดึงข้อมูลผลิตภัณฑ์ที่นี่
  // ตัวอย่างนี้จะคืนค่ารายการผลิตภัณฑ์ว่าง ๆ
  return [];
}
