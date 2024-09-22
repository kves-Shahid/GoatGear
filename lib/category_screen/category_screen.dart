import 'package:flutter/material.dart';
import 'package:emart_app/category_screen/category_details.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/lists.dart';
import 'category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<String>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: 'Categories'.text.fontFamily(bold).white.make(),
        ),
        body: FutureBuilder<List<String>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories found'));
            }

            List<String> categories = snapshot.data!;

            return GridView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 200,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryImage = catimg[index % catimg.length];

                return GestureDetector(
                  onTap: () {
                    Get.to(() => CategoryDetails(category: category));
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        categoryImage,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            color: Colors.grey,
                            child: Center(child: Icon(Icons.error)),
                          );
                        },
                      ),
                      10.heightBox,
                      category.text
                          .color(darkFontGrey)
                          .align(TextAlign.center)
                          .make(),
                    ],
                  ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}