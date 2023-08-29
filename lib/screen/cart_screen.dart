import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:cartapp/helper/db_helper.dart';
import 'package:cartapp/model/cart_model.dart';
import 'package:cartapp/provider/cartprovider.dart';
import 'package:cartapp/screen/product_list.dart' as productCategory;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  bool? valuefirst = false;
  bool? valuesecound = false;
  bool? valuethird = false;
  bool? valuefour = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCounter().toString(),
                      style: TextStyle(color: Colors.white));
                },
              ),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('images/empty_cart.png'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Your cart is empty 😌',
                                style: Theme.of(context).textTheme.headline5),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                'Explore products and shop your\nfavourite items',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2)
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(snapshot
                                                .data![index].image
                                                .toString()),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .productName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          dbHelper!.delete(
                                                              snapshot
                                                                  .data![index]
                                                                  .id!);
                                                          cart.removerCounter();
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .amount
                                                                  .toString()));
                                                        },
                                                        child:
                                                            Icon(Icons.delete))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot.data![index].unitTag
                                                          .toString() +
                                                      " " +
                                                      snapshot
                                                          .data![index].amount
                                                          .toString() +
                                                      r"฿",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;
                                                                  quantity--;
                                                                  int?
                                                                      newPrice =
                                                                      price *
                                                                          quantity;

                                                                  if (quantity >
                                                                      0) {
                                                                    dbHelper!
                                                                        .updateQuantity(Cart(
                                                                            id: snapshot.data![index].id!,
                                                                            productId: snapshot.data![index].id!.toString(),
                                                                            productName: snapshot.data![index].productName!,
                                                                            initialPrice: snapshot.data![index].initialPrice!,
                                                                            amount: newPrice,
                                                                            quantity: quantity,
                                                                            unitTag: snapshot.data![index].unitTag.toString(),
                                                                            image: snapshot.data![index].image.toString()))
                                                                        .then((value) {
                                                                      newPrice =
                                                                          0;
                                                                      quantity =
                                                                          0;
                                                                      cart.removeTotalPrice(double.parse(snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice!
                                                                          .toString()));
                                                                    }).onError((error, stackTrace) {
                                                                      print(error
                                                                          .toString());
                                                                    });
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .quantity
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;
                                                                  quantity++;
                                                                  int?
                                                                      newPrice =
                                                                      price *
                                                                          quantity;

                                                                  dbHelper!
                                                                      .updateQuantity(Cart(
                                                                          id: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id!,
                                                                          productId: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id!
                                                                              .toString(),
                                                                          productName: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .productName!,
                                                                          initialPrice: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .initialPrice!,
                                                                          amount:
                                                                              newPrice,
                                                                          quantity:
                                                                              quantity,
                                                                          unitTag: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .unitTag
                                                                              .toString(),
                                                                          image: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .image
                                                                              .toString()))
                                                                      .then(
                                                                          (value) {
                                                                    newPrice =
                                                                        0;
                                                                    quantity =
                                                                        0;
                                                                    cart.addTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice!
                                                                        .toString()));
                                                                  }).onError((error,
                                                                          stackTrace) {
                                                                    print(error
                                                                        .toString());
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }
                  return Text('');
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(
                  children: [
                    ReusableWidget(
                      title: 'Sub Total',
                      value:
                          value.getTotalPrice().toStringAsFixed(2) + " " + r'฿',
                    ),
                    Container(
                        child: Text(
                      'Coupon',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Row(
                      children: [
                        Column(
                          children: [
                            Checkbox(
                              value: valuefirst,
                              activeColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  valuefirst = value;
                                  if (value != null && value) {
                                    valuesecound = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        ReusableWidget(title: 'Discount 10%', value: ""),
                        Spacer(),
                        Column(
                          children: [
                            Checkbox(
                              value: valuesecound,
                              activeColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  valuesecound = value;
                                  if (value != null && value) {
                                    valuefirst = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        ReusableWidget(title: 'Discount 50 ฿  ', value: "   "),
                      ],
                    ),
                    Container(
                        child: Text(
                      'Ontop',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Row(
                      children: [
                        Checkbox(
                          value: valuethird,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              valuethird = value;
                              if (value != null && value) {
                                valuefour = false;
                              }
                            });
                          },
                        ),
                        ReusableWidget(title: 'OnTop Speacial 15%', value: ""),
                        Spacer(),
                        Checkbox(
                          value: valuefour,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              valuefour = value;
                              if (value != null && value) {
                                valuethird = false;
                              }
                            });
                          },
                        ),
                        ReusableWidget(title: 'OnTop Point 20%', value: ""),
                      ],
                    ),
                    ReusableWidget(
                        title: 'Seasonal Discount',
                        value: calculateDiscount(
                                value.getTotalPrice(),
                                valuefirst!,
                                valuesecound!,
                                valuethird!,
                                valuefour!)
                            .toString()),
                    ReusableWidget(
                      title: 'Total',
                      value: calculateTotalFinal(
                              value.getTotalPrice(),
                              valuefirst!,
                              valuesecound!,
                              valuethird!,
                              valuefour!)
                          .toString(),
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

double calculateDiscount50Baht(double amount) {
  double discount = 50;

  return discount;
}

double calculateDiscount10Percen(double percentage) {
  return percentage * 0.10;
}

// วิธีนี่ยังไม่ถูกต้องเพราะนำค่าที่ได้จากการคำนวนส่วนของ coupon มาคิด พยายามเเก้ไขเเล้วเเต่ไม่สำเร็จภายในเวลาที่กำหนด ต้องนำค่าที่ได้รับมาจาก totalPrice มาคิดเเล้วนำมาใส่
double calculateOntopCategory(String category, double amount) {
  if (category == 'Clothing') {
    double discountAmount = amount * 0.15;
    return discountAmount;
  } else {
    return amount;
  }
}

double calculateOntopPoint(double total) {
  double customerPoint = 1000;
  double maxDiscount = total * 0.20;

  if (customerPoint > maxDiscount) {
    customerPoint = maxDiscount;
  }
  return customerPoint;
}

double calculateDiscount(double every, bool valuefirst, bool valuesecound,
    bool valuethird, bool valuefour) {
  double discount = 40;
  double originalTotal = every;

  if (valuefirst) {
    every -= calculateDiscount10Percen(originalTotal);
  }

  if (valuesecound) {
    every -= calculateDiscount50Baht(originalTotal);
  }

  if (valuethird) {
    every -= calculateOntopCategory('Clothing', originalTotal);
  }

  if (valuefour) {
    every -= calculateOntopPoint(originalTotal);
  }

  return every = (every / 300).floor() * discount;
}

double calculateTotalFinal(double amount, bool valuefirst, bool valuesecound,
    bool valuethird, bool valuefour) {
  double total = amount;
  double every = total;
  if (valuefirst) {
    total -= calculateDiscount10Percen(total);
  }

  if (valuesecound) {
    total -= calculateDiscount50Baht(total);
  }

  if (valuethird) {
    total -= calculateOntopCategory('Clothing', total);
  }

  if (valuefour) {
    total -= calculateOntopPoint(total);
  }
  total -=
      calculateDiscount(every, valuefirst, valuesecound, valuethird, valuefour);
  return total;
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}
