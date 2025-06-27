// lib/features/pharmacie/inventory/view/medicine/addMedicine.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pharmaciyti/core/constants/colors.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/viewmodel/category_viewmodel.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/viewmodel/medicine_viewmodel.dart';

class AddMedicinePage extends StatefulWidget {
  final Medicine? medicine;

  const AddMedicinePage({super.key, this.medicine});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _title;
  double? _actualPrice;
  int? _categoryId;
  int? _quantity;
  bool? _requiresPrescription = false;
  String? _description;
  String? _disclaimer;
  String? _status = 'available';
  final ImagePicker _picker = ImagePicker();

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightGrey, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.medicine != null) {
      _title = widget.medicine!.name;
      _actualPrice = widget.medicine!.price;
      _categoryId = widget.medicine!.categoryId;
      _quantity = widget.medicine!.quantity;
      _requiresPrescription = widget.medicine!.statusPrescription;
      _description = widget.medicine!.description;
      _status = widget.medicine!.status;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineViewModel = Provider.of<MedicineViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicine != null ? 'Edit Medicine' : 'Add Medicine'),
        backgroundColor: AppColors.lightGrey,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Medicine Image',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textBlack),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white,
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : widget.medicine?.image != null
                          ? Image.network(widget.medicine!.image!, fit: BoxFit.cover)
                          : Center(
                              child: Icon(Icons.image_outlined, color: AppColors.primaryGreen, size: 32),
                            ),
                ),
              ),
              SizedBox(height: 18),

              Text('Medicine Title', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                initialValue: _title,
                decoration: inputDecoration('Enter Medicine Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medicine title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Actual Price', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                initialValue: _actualPrice?.toString(),
                decoration: inputDecoration('Enter Medicine Actual Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an actual price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _actualPrice = double.parse(value!),
              ),
              SizedBox(height: 16),

              Text('Medicine Category', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: inputDecoration('Select Category'),
                items: categoryViewModel.categories
                    .map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name)))
                    .toList(),
                onChanged: (value) => setState(() => _categoryId = value),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 16),

              Text('Medicine Quantity Limit', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                initialValue: _quantity?.toString(),
                decoration: inputDecoration('Enter Medicine Quantity Limit'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _quantity = value != null && value.isNotEmpty ? int.parse(value) : null,
              ),
              SizedBox(height: 16),

              Text('Medicine Required Prescription?', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              DropdownButtonFormField<bool>(
                value: _requiresPrescription,
                decoration: inputDecoration('Select'),
                items: [true, false].map((val) => DropdownMenuItem(value: val, child: Text(val ? 'Yes' : 'No'))).toList(),
                onChanged: (value) => setState(() => _requiresPrescription = value),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),
              SizedBox(height: 16),

              Text('Medicine Description', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                initialValue: _description,
                decoration: inputDecoration('Add Medicine Description..'),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Disclaimer', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                initialValue: _disclaimer,
                decoration: inputDecoration('Add Disclaimer'),
                maxLines: 3,
                onSaved: (value) => _disclaimer = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Status', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: inputDecoration('Select Status'),
                items: ['available', 'out_of_stock']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: medicineViewModel.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final newMedicine = Medicine(
                              id: widget.medicine?.id,
                              name: _title!,
                              categoryId: _categoryId,
                              price: _actualPrice!,
                              quantity: _quantity ?? 0,
                              status: _status!,
                              description: _description,
                              statusPrescription: _requiresPrescription!,
                            );

                            try {
                              if (widget.medicine != null) {
                                await medicineViewModel.updateMedicine(
                                  widget.medicine!.id!,
                                  newMedicine,
                                  image: _selectedImage,
                                );
                              } else {
                                await medicineViewModel.addMedicine(
                                  newMedicine,
                                  image: _selectedImage,
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Medicine $_title ${widget.medicine != null ? 'updated' : 'added'}'),
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(medicineViewModel.errorMessage ?? 'Error: $e')),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  ),
                  child: medicineViewModel.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.medicine != null ? 'Update' : 'Add',
                          style: TextStyle(fontSize: 16.0),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}