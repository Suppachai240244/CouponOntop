import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:cartapp/helper/db_helper.dart';
import 'package:cartapp/model/cart_model.dart';
import 'package:cartapp/provider/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<String> productName = [
    'T-Shirt',
    'Hat',
    'Watch',
    'Bag',
    'Belt',
    'Hoodie',
    'Plant',
    'Shoulder Bag'
  ];
  static List<String> productCategory = [
    'Clothing',
    'Clothing',
    'Electronics',
    'Accessories',
    'Accessories',
    'Clothing',
    'Clothing',
    'Clothing'
  ];
  List<int> amount = [350, 250, 850, 640, 230, 700, 1290, 590];
  List<String> productImage = [
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/455365/sub/goods_455365_sub14.jpg?width=750',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/459760/item/goods_56_459760.jpg?width=750',
    'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/watch-ultra-digitalmat-gallery-3-202209_GEO_US?wid=364&hei=333&fmt=png-alpha&.v=1661557390611',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/459777/item/goods_09_459777.jpg?width=750',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/463628/item/goods_09_463628.jpg?width=750',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/453773/sub/goods_453773_sub15.jpg?width=750',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/452112/sub/goods_452112_sub14.jpg?width=750',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/457244/item/goods_12_457244.jpg?width=750',
    'https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/457244/item/goods_12_457244.jpg?width=750'
  ];

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString(),
                        style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: productName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(
                                    productImage[index].toString()),
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                              // )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productCategory[index].toString() +
                                        " " +
                                        amount[index].toString() +
                                        r"฿",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        dbHelper!
                                            .insert(Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index]
                                                    .toString(),
                                                initialPrice: amount[index],
                                                amount: amount[index],
                                                quantity: 1,
                                                unitTag: productCategory[index]
                                                    .toString(),
                                                image: productImage[index]
                                                    .toString()))
                                            .then((value) {
                                          cart.addTotalPrice(double.parse(
                                              amount[index].toString()));
                                          cart.addCounter();

                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Product is added to cart'),
                                            duration: Duration(seconds: 1),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }).onError((error, stackTrace) {
                                          print("error" + error.toString());
                                          final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Product is already added in cart'),
                                              duration: Duration(seconds: 1));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                          child: Text(
                                            'Add to cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                          // );
                        ]));
                  }),
            ),
          )
        ],
      ),
    );
  }
}
