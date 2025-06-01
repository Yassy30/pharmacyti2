// lib/features/pharmacie/inventory/view/category/category.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/viewmodel/category_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/view/category/addCategory.dart';
import 'package:pharmaciyti/core/constants/colors.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Category'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCategoryPage()),
                  );
                },
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
                  ? Center(child: Text(viewModel.errorMessage!))
                  : viewModel.categories.isEmpty
                      ? const Center(child: Text('No categories found'))
                      : ListView.builder(
                          itemCount: viewModel.categories.length,
                          itemBuilder: (context, index) {
                            final category = viewModel.categories[index];
                            return _buildCategoryItem(context, category, viewModel);
                          },
                        ),
        );
      },
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category, CategoryViewModel viewModel) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            category.image != null
                ? Image.network(
                    category.image!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.description,
                      color: Colors.green,
                      size: 40.0,
                    ),
                  )
                : const Icon(
                    Icons.description,
                    color: Colors.green,
                    size: 40.0,
                  ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    category.status == 'available' ? 'Available' : 'Out of Stock',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCategoryPage(category: category),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Category'),
                    content: Text('Are you sure you want to delete ${category.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await viewModel.deleteCategory(category.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Category ${category.name} deleted')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(viewModel.errorMessage ?? 'Error: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}