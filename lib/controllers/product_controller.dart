import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/varibles.dart';
import 'package:natthawut_flutter_049/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductController {
  // Function to get products
  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('$apiURL/api/products'),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => ProductModel.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  // Function to add a product
  Future<void> addProduct(String accessToken, ProductModel product) async {
    final response = await http.post(
      Uri.parse('$apiURL/api/product'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: productModelToJson(product), // Serialize product to JSON
    );

    if (response.statusCode != 201) { // Check for 201 Created status
      throw Exception('Failed to add product: ${response.body}');
    }
  }

  // Function to delete a product
  Future<void> deleteProduct(String accessToken, String Id) async {
    final response = await http.delete(
      Uri.parse('$apiURL/api/product/$Id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode != 204) { // Assuming a successful deletion returns a 204 No Content
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  // Function to update a product
  Future<void> updateProduct(String accessToken, String Id, ProductModel product) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/product/$Id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: productModelToJson(product), // Use the correct serialization
    );

    if (response.statusCode != 200) { // Assuming a successful update returns a 200 OK
      throw Exception('Failed to update product: ${response.body}');
    }
  }
}
