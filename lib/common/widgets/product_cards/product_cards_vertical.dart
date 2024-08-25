import 'dart:convert';

import 'package:a/Features/widgets/product/product_details.dart';
import 'package:a/Services/models/product_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Features/widgets/product/product_card.dart';
import '../../../Services/API/get_product_service.dart';
import 'package:http/http.dart' as http;

class AProductCardVertical extends StatefulWidget {
  AProductCardVertical({
    super.key,
  });

  @override
  State<AProductCardVertical> createState() => _AProductCardVerticalState();
}

class _AProductCardVerticalState extends State<AProductCardVertical> {
  var dataReceived = [];
  int? i;
  getProduct() async {
    Uri url = Uri.parse("http://arabeity.runasp.net/api/product");
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    dataReceived = List.from(data);
    print(dataReceived.runtimeType);
    return dataReceived;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: dataReceived.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(ProductDetails(

                        image: dataReceived[index]["picture"],
                        name: dataReceived[index]["name"],
                        description: dataReceived[index]["description"],
                        price: dataReceived[index]["price"],
                      ));
                    },
                    child: product_card(
                        productImage: dataReceived[index]["picture"],
                        productName: dataReceived[index]["name"],
                        productCategory: dataReceived[index]["productCategory"],
                        price: dataReceived[index]["price"],
                        fit: BoxFit.cover),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

/*
Container(
                  child: Image.memory(base64Decode(
                    dataReceived[0]["picture"],
                  )))
 */

/*
ListView(
                physics: const NeverScrollableScrollPhysics(),
                children:  [
                  product_card(
                    productImage: "assets/images/Cars/1.jpg",
                    price: dataReceived[0]["price"].toString(),
                    productCategory: "Family Car",
                    productName: dataReceived[0]["name"],
                    fit: BoxFit.cover,
                  ),
                  const product_card(
                    productImage: "assets/images/Cars/2.jpg",
                    price: "185000",
                    productCategory: "Family Car",
                    productName: "BMW 530d Touring xDrive 210 kW",
                    fit: BoxFit.cover,
                  ),
                  const product_card(
                    productImage: "assets/images/Cars/3.jpg",
                    price: "85000",
                    productCategory: "Family Car",
                    productName: "Opel Mokka 1.2 Elegance 96 kW",
                    fit: BoxFit.cover,
                  ),
                  const product_card(
                    productImage: "assets/images/Cars/4.jpg",
                    price: "78900",
                    productCategory: "Family Car",
                    productName: "Renault Captur Blue dCi 95 70 kW",
                    fit: BoxFit.cover,
                  ),
                  const product_card(
                    productImage: "assets/images/Cars/6.jpg",
                    price: "98000",
                    productCategory: "Family Car",
                    productName: "Skoda Karoq 110 kW",
                    fit: BoxFit.cover,
                  ),
                ],
              );
 */

//(GridView.builder(
//               itemCount: dataReceived.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1),
//                 itemBuilder: (context, index) {
//                   return product_card(productImage: "assets/images/Cars/2.jpg", fit: BoxFit.contain,productModel: dataReceived[index],);
//                 });
// )
