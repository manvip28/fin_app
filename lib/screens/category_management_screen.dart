// lib/screens/category_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(int.parse(category.color.replaceAll('#', '0xFF'))),
              child: Icon(IconData(int.parse(category.icon), fontFamily: 'MaterialIcons')),
            ),
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditCategoryDialog(context, category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteCategoryDialog(context, category),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    String iconCode = '0xe25a'; // Default icon (shopping cart)
    String colorCode = '#4CAF50'; // Default color (green)

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Icon:'),
                  IconButton(
                    icon: Icon(IconData(int.parse(iconCode), fontFamily: 'MaterialIcons')),
                    onPressed: () {
                      // Show icon picker (simplified)
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Icon'),
                          content: SingleChildScrollView(
                            child: Wrap(
                              spacing: 10,
                              children: [
                                _iconOption(context, '0xe25a', iconCode, (value) { // shopping_cart
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe318', iconCode, (value) { // home
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe8f9', iconCode, (value) { // work
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe581', iconCode, (value) { // local_dining
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe05e', iconCode, (value) { // directions_car
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Color:'),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(int.parse(colorCode.replaceAll('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        // Show color picker (simplified)
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Select Color'),
                            content: SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                children: [
                                  _colorOption(context, '#4CAF50', colorCode, (value) { // Green
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#2196F3', colorCode, (value) { // Blue
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#F44336', colorCode, (value) { // Red
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#FF9800', colorCode, (value) { // Orange
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#9C27B0', colorCode, (value) { // Purple
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);

                final newCategory = Category(
                  name: nameController.text,
                  icon: iconCode,
                  color: colorCode,
                );

                categoryProvider.addCategory(newCategory);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    final nameController = TextEditingController(text: category.name);
    String iconCode = category.icon;
    String colorCode = category.color;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Icon:'),
                  IconButton(
                    icon: Icon(IconData(int.parse(iconCode), fontFamily: 'MaterialIcons')),
                    onPressed: () {
                      // Show icon picker (simplified)
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Icon'),
                          content: SingleChildScrollView(
                            child: Wrap(
                              spacing: 10,
                              children: [
                                _iconOption(context, '0xe25a', iconCode, (value) { // shopping_cart
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe318', iconCode, (value) { // home
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe8f9', iconCode, (value) { // work
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe581', iconCode, (value) { // local_dining
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                                _iconOption(context, '0xe05e', iconCode, (value) { // directions_car
                                  iconCode = value;
                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Color:'),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(int.parse(colorCode.replaceAll('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        // Show color picker (simplified)
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Select Color'),
                            content: SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                children: [
                                  _colorOption(context, '#4CAF50', colorCode, (value) { // Green
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#2196F3', colorCode, (value) { // Blue
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#F44336', colorCode, (value) { // Red
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#FF9800', colorCode, (value) { // Orange
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                  _colorOption(context, '#9C27B0', colorCode, (value) { // Purple
                                    colorCode = value;
                                    Navigator.pop(context);
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);

                final updatedCategory = Category(
                  id: category.id,
                  name: nameController.text,
                  icon: iconCode,
                  color: colorCode,
                );

                categoryProvider.updateCategory(updatedCategory);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }