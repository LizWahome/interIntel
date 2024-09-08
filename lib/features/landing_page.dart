import 'package:flutter/material.dart';
import 'package:inter_intel/features/add_product.dart';
import 'package:inter_intel/utils/asset_urls.dart';
import 'package:inter_intel/utils/text_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetUrls.addProduct),
          Text(
            "First up, what are you selling?",
            style: context.titleText?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
              "Before you open your store, you need to add some products"),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AddProduct()));
                  },
                  child: Text(
                    "Add your products",
                    style: context.titleMedium?.copyWith(color: Colors.white),
                  )),
              const SizedBox(
                width: 7,
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                          side: const BorderSide(color: Colors.green))),
                  onPressed: () {},
                  child: Text(
                    "Find products to sell",
                    style: context.titleMedium?.copyWith(color: Colors.black),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
