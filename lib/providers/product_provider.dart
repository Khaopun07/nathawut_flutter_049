import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/models/product_model.dart';
import 'package:natthawut_flutter_049/controllers/product_controller.dart';

class ProductProvider with ChangeNotifier {
  final ProductController _productController = ProductController();
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productController.getProducts();
      _errorMessage = null; // Clear previous errors
    } catch (e) {
      _errorMessage = e.toString();
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
