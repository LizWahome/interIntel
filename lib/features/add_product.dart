import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inter_intel/utils/text_styles.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController optionNameController = TextEditingController();
  TextEditingController optionValueController = TextEditingController();
  List<XFile> imageList = [];
  bool isChecked = false;
  List<Map<String, dynamic>> options =
      []; 
  List<String> optionValues = [];
  List<Map<String, dynamic>> variants = [];
  bool selectAll = false;

  void selectImages() async {
    final ImagePicker imagePicker = ImagePicker();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageList.addAll(selectedImages);
    }
    setState(() {});
  }

  void addOptionValue() {
    if (optionValueController.text.isNotEmpty) {
      setState(() {
        optionValues.add(optionValueController.text);
        optionValueController.clear();
      });
    }
  }

  void addOption() {
    if (optionNameController.text.isNotEmpty && optionValues.isNotEmpty) {
      setState(() {
        options.add({
          'name': optionNameController.text,
          'values': List<String>.from(optionValues)
        });
        
        optionNameController.clear();
        optionValues.clear();
      });
    }
  }

  List<String> generateCombinations() {
    List<String> result = [];

    if (options.isEmpty) return result;

    
    List<List<String>> valueLists = options.map((option) {
      return List<String>.from(option['values']);
    }).toList();

    void cartesian(List<List<String>> lists, List<String> current, int depth) {
      if (depth == lists.length) {
        result.add(current.join('/'));
        return;
      }
      for (int i = 0; i < lists[depth].length; i++) {
        List<String> newList = List<String>.from(current);
        newList.add(lists[depth][i]);
        cartesian(lists, newList, depth + 1);
      }
    }

    cartesian(valueLists, [], 0);
    return result;
  }

  void generateVariants() {
    List<String> combinations = generateCombinations();
    variants = combinations
        .map((combination) => {
              'name': combination,
              'price': 0.0,
              'quantity': 0,
              'selected': false,
            })
        .toList();
    setState(() {});
  }

  void updateQuantity(int index, bool isIncrement) {
    setState(() {
      if (isIncrement) {
        variants[index]['quantity'] += 1;
      } else if (variants[index]['quantity'] > 0) {
        variants[index]['quantity'] -= 1;
      }
    });
  }

  void toggleSelectAll(bool value) {
    setState(() {
      selectAll = value;
      for (var variant in variants) {
        variant['selected'] = value;
      }
    });
  }

  void toggleSelect(int index, bool? value) {
    setState(() {
      variants[index]['selected'] = value!;
      selectAll = variants.every((variant) => variant['selected']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe3f8fa),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: ListView(
          
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                Text(
                  "Add Product",
                  style:
                      context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            
            const TextWidget(title: "Title"),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter title"),
            ),
            const SizedBox(
              height: 7,
            ),
            
            const TextWidget(title: "Description"),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter description"),
            ),

            
            const SizedBox(
              height: 7,
            ),
            
            const TextWidget(title: "Media"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(7)),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  onPressed: selectImages,
                  child: Text(
                    "Add file",
                    style: context.titleMedium,
                  )),
            ),
            Visibility(
              visible: imageList.isNotEmpty,
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(imageList[index].path),
                          width: 80,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
              ),
            ),
            
            
            const SizedBox(
              height: 7,
            ),
            const TextWidget(title: "Options"),
            CheckboxListTile(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
              title: const Text("This product has options like size or color"),
            ),
            if (isChecked)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  ...options.map((option) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Option: ${option['name']}",
                            style: context.titleMedium),
                        Wrap(
                          spacing: 8.0,
                          children:
                              List<String>.from(option['values']).map((value) {
                            return Chip(label: Text(value));
                          }).toList(),
                        ),
                        const SizedBox(height: 7),
                      ],
                    );
                  }),
                  const TextWidget(title: "Option Name"),
                  TextFormField(
                    controller: optionNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter option name"),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const TextWidget(title: "Option values"),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: optionValueController,
                          decoration: const InputDecoration(
                            hintText: 'Enter option value',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: addOptionValue,
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  
                  Wrap(
                    spacing: 8.0,
                    children: optionValues.map((value) {
                      return Chip(label: Text(value));
                    }).toList(),
                  ),
                  const SizedBox(height: 7),
                  
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: addOption,
                        child: const Text("Add Option"),
                      ),
                     const SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: generateVariants,
                        child: const Text("Done"),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 7),
                  const Divider(),
                  const SizedBox(height: 20),

                  if (options.isNotEmpty)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(title: "Variants"),
                          CheckboxListTile(
                            title: const Text("Select All"),
                            value: selectAll,
                            onChanged: (value) {
                              toggleSelectAll(value!);
                            },
                          ),
                          ...variants.asMap().entries.map((entry) {
                            int index = entry.key;
                            var variant = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: [
                                  
                                  SizedBox(
                                    width: 90,
                                    child: FittedBox(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: variant['selected'],
                                            onChanged: (value) =>
                                                toggleSelect(index, value),
                                          ),
                                          Text(variant['name']),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: variant['price'].toString(),
                                      decoration: const InputDecoration(
                                        hintText: 'Ksh 0.00',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          variant['price'] =
                                              double.tryParse(value);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_drop_up),
                                          onPressed: () =>
                                              updateQuantity(index, true),
                                        ),
                                        Text(variant['quantity'].toString()),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_drop_down),
                                          onPressed: () =>
                                              updateQuantity(index, false),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("Edit"),
                                  )
                                ],
                              ),
                            );
                          }),
                        ]),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String title;
  const TextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: context.titleText,
      ),
    );
  }
}
