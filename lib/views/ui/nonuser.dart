import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_shop/views/shared/appstyle.dart';
import 'package:online_shop/views/shared/export_packages.dart';
import 'package:online_shop/views/shared/reuseable_text.dart';
import 'package:online_shop/views/ui/auth/login.dart';

class NonUser extends StatelessWidget {
  const NonUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
          elevation: 0,
          leading: const Icon(
            MaterialCommunityIcons.qrcode_scan,
            size: 18,
            color: Colors.black,
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/usa.svg',
                      width: 15,
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      height: 15.h,
                      width: 1.w,
                      color: Colors.grey,
                    ),
                    reusableText(
                        text: " USA",
                        style: appstyle(16, Colors.black, FontWeight.normal)),
                    SizedBox(
                      width: 10.w,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(
                        SimpleLineIcons.settings,
                        color: Colors.black,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 750.h,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 40.h,
                                width: 35.w,
                                child: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/user.jpeg'),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: reusableText(
                                    text:
                                        "Hello, Please Login into Your Account",
                                    style: appstyle(12, Colors.grey.shade600,
                                        FontWeight.normal)),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: 50.w,
                              height: 30.h,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: reusableText(
                                    text: "Login",
                                    style: appstyle(
                                        12, Colors.white, FontWeight.normal)),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]))
            ],
          ),
        )
        );
  
  }

}
