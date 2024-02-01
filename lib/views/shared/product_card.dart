import 'package:flutter/material.dart';
import 'package:online_shop/controllers/login_provider.dart';
import 'package:online_shop/views/ui/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:online_shop/models/constants.dart';
import 'package:online_shop/views/shared/export.dart';
import 'package:online_shop/views/shared/export_packages.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.price,
    required this.category,
    required this.id,
    required this.name,
    required this.image,
  }) : super(key: key);

  final String price;
  final String category;
  final String id;
  final String name;
  final String image;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late Box _favBox;

  @override
  void initState() {
    super.initState();
    _favBox = Hive.box('fav_box');
    getFavorites();
  }

  Future<void> _createFav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
    getFavorites();
  }

  void getFavorites() {
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);

      return {
        "key": key,
        "id": item['id'], // Fix: Use 'id' from item instead of a string literal
      };
    }).toList();

    favor = favData.toList();
    ids = favor.map((item) => item['id']).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool selected = true;
    var favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 1,
              blurRadius: 0.6,
              offset: Offset(1, 1),
            )
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(widget.image)),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Consumer<FavoritesNotifier>(
                      builder: (context, favoritesNotifier, child) {
                        return Consumer<LoginNotifier>(
                          builder: (context, authNotifier, child) {
                            return GestureDetector(
                              onTap: () async {
                                if (authNotifier.loggeIn == true) {
                                  if (favoritesNotifier.ids
                                      .contains(widget.id)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Favorites(),
                                      ),
                                    );
                                  } else {
                                    _createFav({
                                      "id": widget.id,
                                      "name": widget.name,
                                      "category": widget.category,
                                      "price": widget.price,
                                      "imageUrl": widget.image,
                                    });
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                }
                              },
                              child: favoritesNotifier.ids.contains(widget.id)
                                  ? const Icon(AntDesign.heart)
                                  : const Icon(AntDesign.hearto),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableText(
                      text: widget.name,
                      style: appstyleWithHt(
                        30,
                        Colors.black,
                        FontWeight.w900,
                        1.5,
                      ),
                    ),
                    reusableText(
                      text: widget.category,
                      style: appstyleWithHt(
                        18,
                        Colors.grey,
                        FontWeight.bold,
                        1.5,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    reusableText(
                      text: widget.price,
                      style: appstyle(24, Colors.black, FontWeight.w600),
                    ),
                    Row(
                      children: [
                        reusableText(
                          text: "Colors",
                          style: appstyle(18, Colors.grey, FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ChoiceChip(
                          label: const Text(" "),
                          selected: selected,
                          visualDensity: VisualDensity.compact,
                          selectedColor: Colors.black,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle appstyleWithHt(
    double fontSize,
    Color color,
    FontWeight fontWeight,
    double height,
  ) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
    );
  }
}
