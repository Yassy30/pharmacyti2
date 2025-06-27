// lib/features/pharmacie/inventory/view/medicine/medicine.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/core/constants/colors.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/view/medicine/addMedcine.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/viewmodel/medicine_viewmodel.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<MedicineViewModel>(context, listen: false).fetchMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicineViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Medicine'),
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textBlack,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primaryGreen),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMedicinePage()),
                  );
                },
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.errorMessage != null
                  ? Center(child: Text(viewModel.errorMessage!))
                  : viewModel.medicines.isEmpty
                      ? const Center(child: Text('No medicines found'))
                      : ListView.builder(
                          itemCount: viewModel.medicines.length,
                          itemBuilder: (context, index) {
                            final medicine = viewModel.medicines[index];
                            return _buildMedicineItem(context, medicine, viewModel);
                          },
                        ),
        );
      },
    );
  }

  Widget _buildMedicineItem(
    BuildContext context,
    Medicine medicine,
    MedicineViewModel viewModel,
  ) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            medicine.image != null
                ? CachedNetworkImage(
                    imageUrl: medicine.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: AppColors.textGrey,
                    ),
                  )
                : const Icon(
                    Icons.medication,
                    size: 80,
                    color: AppColors.textGrey,
                  ),
            const SizedBox(width: 16.0),
            Expanded(
  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      FutureBuilder<String>(
                        future: _getCategoryName(medicine.categoryId),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.hasData
                                ? snapshot.data!
                                : 'Category ID: \${medicine.categoryId ?? "Not assigned"}',
                            style: const TextStyle(fontSize: 14.0, color: AppColors.textGrey),
                          );
                        },
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text(
                            '\$${medicine.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.priceBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryGreen),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMedicinePage(medicine: medicine),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Medicine'),
                    content: Text('Are you sure you want to delete ${medicine.name}?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await viewModel.deleteMedicine(medicine.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Medicine ${medicine.name} deleted')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${viewModel.errorMessage}')),
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

  Future<String> _getCategoryName(int? categoryId) async {
    if (categoryId == null) return 'Not assigned';
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('category')
        .select('name')
        .eq('id', categoryId)
        .single();
    return response['name'] ?? 'Unknown Category';
  }
}