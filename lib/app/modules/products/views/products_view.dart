import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/data/models/products_model.dart';
import 'package:qr_code/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCTS'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products"),
            );
          }

          List<ProductModel> allProducts = [];

          for (var element in snapshot.data!.docs) {
            allProducts.add(
                ProductModel.fromJson(element.data() as Map<String, dynamic>));
          }

          return ListView.builder(
            itemCount: allProducts.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              ProductModel product =
                  allProducts[index]; // corrected index access

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.detailProduct);
                  },
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(product
                                  .name), // removed quotes to get the value of name
                              Text("Jumlah = ${product.qty}"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code, // corrected product code
                            version: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
