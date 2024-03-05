import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:online_shop/models/orders/order_res.dart';
import 'package:online_shop/services/cart_helper.dart';
import 'package:online_shop/views/shared/export.dart';

class ProcessOrders extends StatefulWidget {
  const ProcessOrders({Key? key}) : super(key: key);

  @override
  State<ProcessOrders> createState() => _ProcessOrdersState();
}

class _ProcessOrdersState extends State<ProcessOrders> {
  Future<List<PaidOrders>>? _orders;

  @override
  void initState() {
    super.initState();
    _orders = CartHelper().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.h,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 825.h,
          width: 325.w,
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reusableText(
                  text: "My Orders",
                  style: appstyle(36, Colors.white, FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  height: 700.h,
                  width: 400.h,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.white,
                  ),
                  child: FutureBuilder<List<PaidOrders>>(
                    future: _orders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: reusableText(
                            text: "Error ${snapshot.error}",
                            style: appstyle(18, Colors.black, FontWeight.bold),
                          ),
                        );
                      } else {
                        final products = snapshot.data;

                        return ListView.builder(
                          itemCount: products!.length,
                          itemBuilder: ((context, index) {
                            var order = products[index];

                            return Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              height: 78.h,
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.network(
                                              order.productId.imageUrl[0]),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          reusableText(
                                            text: order.productId.name,
                                            style: appstyle(12, Colors.black,
                                                FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          SizedBox(
                                            width: 325 * 0.6,
                                            child: FittedBox(
                                              child: reusableText(
                                                text: order.productId.title,
                                                style: appstyle(
                                                    12,
                                                    Colors.grey.shade700,
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          reusableText(
                                            text:
                                                " \$ ${order.productId.price}",
                                            style: appstyle(
                                                10,
                                                Colors.grey.shade600,
                                                FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: reusableText(
                                          text: "PAID",
                                          style: appstyle(11, Colors.white,
                                              FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                              MaterialCommunityIcons
                                                  .truck_fast_outline,
                                              size: 16),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          reusableText(
                                            text: order.deliveryStatus
                                                .toUpperCase(),
                                            style: appstyle(10, Colors.black,
                                                FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
