import 'package:app/core/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final VoidCallback onAddToCartPressed;
  final VoidCallback onAddToFavoritesPressed;
  final Item item;
  const ItemCard({
    required this.item,
    required this.onAddToFavoritesPressed,
    required this.onAddToCartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Card(
                  margin: const EdgeInsets.all(0),
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: true,
                  shape: Border.all(color: Colors.black, width: 0.5),
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: Image.asset(item.image, fit: BoxFit.cover),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        onPressed: onAddToCartPressed,
                        color: Colors.black,
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            height: 72,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            item.name.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: GoogleFonts.mavenPro().fontFamily,
                                letterSpacing: 0.5),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: onAddToFavoritesPressed,
                          child: const Icon(
                            Icons.bookmark_border,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.price.toString()}€',
                    style: TextStyle(
                        fontFamily: GoogleFonts.mavenPro().fontFamily,
                        letterSpacing: 0.5,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
