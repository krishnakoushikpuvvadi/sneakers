import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_shop/controllers/login_provider.dart';
import 'package:online_shop/views/shared/export.dart';
import 'package:online_shop/views/shared/export_packages.dart';
import 'package:online_shop/views/shared/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();

    // Fetch data only once when the widget is created
    fetchData();
  }

  Future<void> fetchData() async {
    var productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    var favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);
    var authNotifier = Provider.of<LoginNotifier>(context, listen: false);

    productNotifier.getFemale();
    productNotifier.getMale();
    productNotifier.getkids();

    await favoritesNotifier.getFavorites();
    await authNotifier.getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: 812.h,
        width: 375.w,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 45.h, 0, 0),
              height: 325.h,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/top_image.png"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: EdgeInsets.only(left: 10.w, bottom: 15.h),
                width: 375.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableText(
                      text: "Athletics Shoes",
                      style: appstyleWithHt(
                          40, Colors.white, FontWeight.w800, 1.0),
                    ),
                    reusableText(
                        text: "Collection",
                        style: appstyleWithHt(
                            40, Colors.white, FontWeight.w800, 1.0)),
                    TabBar(
                      padding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.transparent,
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      labelStyle: appstyle(24, Colors.white, FontWeight.bold),
                      unselectedLabelColor: Colors.grey.withOpacity(0.3),
                      tabs: const [
                        Tab(
                          text: "Men Shoes",
                        ),
                        Tab(
                          text: "Women Shoes",
                        ),
                        Tab(
                          text: "Kids Shoes",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25),
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                child: TabBarView(controller: _tabController, children: [
                  HomeWidget(
                    male: Provider.of<ProductNotifier>(context).male,
                    tabIndex: 0,
                  ),
                  HomeWidget(
                    male: Provider.of<ProductNotifier>(context).female,
                    tabIndex: 1,
                  ),
                  HomeWidget(
                    male: Provider.of<ProductNotifier>(context).kids,
                    tabIndex: 2,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle appstyleWithHt(
      double fontSize, Color color, FontWeight fontWeight, double height) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
    );
  }
}
