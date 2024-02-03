import 'package:hive/hive.dart';
import 'package:online_shop/controllers/login_provider.dart';
import 'package:online_shop/models/cart/add_to_cart.dart';
import 'package:online_shop/services/cart_helper.dart';
import 'package:online_shop/views/shared/export.dart';
import 'package:online_shop/views/shared/export_packages.dart';
import 'package:online_shop/views/ui/auth/login.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.sneakers});

  final Sneakers sneakers;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  final _cartBox = Hive.box('cart_box');
  final _favBox = Hive.box('fav_box');

  Future<void> _createCart(Map<dynamic, dynamic> newCart) async {
    await _cartBox.add(newCart);
  }

  Future<void> _createFav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
    getFavorites();
  }


  getFavorites() {
    var favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);

      return {
        "key": key,
        "id": item['id'],
      };
    }).toList();

    favoritesNotifier.favorites = favData.toList();
    favoritesNotifier.favorites.map((item) => item['id']).toList();
  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    var authNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      body: Consumer<ProductNotifier>(
        builder: (context, productNotifier, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // productNotifier.shoeSizes.clear();
                        },
                        child: const Icon(
                          AntDesign.close,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (authNotifier.loggeIn == true) {
                            if (favoritesNotifier.ids
                                .contains(widget.sneakers.id)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Favorites()));
                            } else {
                              _createFav({
                                "id": widget.sneakers.id,
                                "name": widget.sneakers.name,
                                "category": widget.sneakers.category,
                                "price": widget.sneakers.price,
                                "imageUrl": widget.sneakers.imageUrl[0],
                              });
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          }
                        },
                        child:
                            favoritesNotifier.ids.contains(widget.sneakers.id)
                                ? const Icon(
                                    AntDesign.heart,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    AntDesign.hearto,
                                    color: Colors.black,
                                  ),
                      )
                    ],
                  ),
                ),
                pinned: true,
                snap: false,
                floating: true,
                backgroundColor: Colors.transparent,
                expandedHeight: MediaQuery.of(context).size.height,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.sneakers.imageUrl.length,
                            controller: pageController,
                            onPageChanged: (page) {
                              productNotifier.activePage = page;
                            },
                            itemBuilder: (context, int index) {
                              return Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.39,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey.shade300,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.sneakers.imageUrl[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 0.h,
                                      right: 0,
                                      left: 0,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List<Widget>.generate(
                                            widget.sneakers.imageUrl.length,
                                            (index) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        productNotifier
                                                                    .activepage !=
                                                                index
                                                            ? Colors.grey
                                                            : Colors.black,
                                                  ),
                                                )),
                                      )),
                                ],
                              );
                            }),
                      ),
                      Positioned(
                          bottom: 18,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.645,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    reusableText(
                                      text: widget.sneakers.name,
                                      style: appstyle(
                                          34, Colors.black, FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.sneakers.category,
                                          style: appstyle(
                                              20, Colors.grey, FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        RatingBar.builder(
                                          initialRating: 4,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 22,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${widget.sneakers.price}",
                                          style: appstyle(26, Colors.black,
                                              FontWeight.w600),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Colors",
                                              style: appstyle(18, Colors.black,
                                                  FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const CircleAvatar(
                                              radius: 7,
                                              backgroundColor: Colors.black,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const CircleAvatar(
                                              radius: 7,
                                              backgroundColor: Colors.red,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Select sizes",
                                              style: appstyle(20, Colors.black,
                                                  FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "View size guide",
                                              style: appstyle(20, Colors.grey,
                                                  FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: ListView.builder(
                                              itemCount: productNotifier
                                                  .shoeSizes.length,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                final sizes = productNotifier
                                                    .shoeSizes[index];

                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  child: ChoiceChip(
                                                    disabledColor: Colors.white,
                                                    label: Text(
                                                      sizes['size'],
                                                      style: appstyle(
                                                          16,
                                                          sizes['isSelected']
                                                              ? Colors.white
                                                              : Colors.black,
                                                          FontWeight.w500),
                                                    ),
                                                    selectedColor: Colors.black,
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    selected:
                                                        sizes['isSelected'],
                                                    onSelected: (newState) {
                                                      if (productNotifier.sizes
                                                          .contains(
                                                              sizes['size'])) {
                                                        productNotifier.sizes
                                                            .remove(
                                                                sizes['size']);
                                                      } else {
                                                        productNotifier.sizes
                                                            .add(sizes['size']);
                                                      }
                                                      print(productNotifier
                                                          .sizes);
                                                      productNotifier
                                                          .toggleCheck(index);
                                                    },
                                                  ),
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                      indent: 10,
                                      endIndent: 10,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        widget.sneakers.title,
                                        maxLines: 2,
                                        style: appstyle(
                                            20, Colors.black, FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      widget.sneakers.description,
                                      textAlign: TextAlign.justify,
                                      maxLines: 4,
                                      style: appstyle(
                                          12, Colors.black, FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: CheckoutButton(
                                          onTap: () async {
                                            if (authNotifier.loggeIn == true) {
                                              AddToCart model = AddToCart(
                                                cartItem: widget.sneakers.id,
                                                quantity: 1,
                                              );
                                              CartHelper().addToCart(model);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                              );
                                            }
                                          },
                                          label: "Add to Cart",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
