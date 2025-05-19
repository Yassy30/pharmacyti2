import 'package:flutter/material.dart';
import 'package:pharmaciyti/utils/colors.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  String? _imagePath;
  String? _title;
  String? _actualPrice;
  String? _category;
  String? _quantity;
  bool? _requiresPrescription = false;
  String? _description;
  String? _disclaimer;
  String? _status = 'Publish';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
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
                onTap: () {
                  // TODO: Implement image picker
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white,
                  ),
                  child: Center(
                    child: Icon(Icons.image_outlined, color: AppColors.primaryGreen, size: 32),
                  ),
                ),
              ),
              SizedBox(height: 18),

              Text('Medicine Title', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
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
                decoration: inputDecoration('Enter Medicine Actual Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an actual price';
                  }
                  return null;
                },
                onSaved: (value) => _actualPrice = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Category', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: inputDecoration('Select Category'),
                items: ['Dandruff', 'Pain relief', 'Vaccines', 'Allergies', 'Bacterial Infections']
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 16),

              Text('Medicine Quantity Limit', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                decoration: inputDecoration('Enter Medicine Quantity Limit'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _quantity = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Required Prescription?', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              DropdownButtonFormField<bool>(
                decoration: inputDecoration('Select'),
                items: [true, false].map((val) => DropdownMenuItem(value: val, child: Text(val ? 'Yes' : 'No'))).toList(),
                onChanged: (value) => setState(() => _requiresPrescription = value),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),
              SizedBox(height: 16),

              Text('Medicine Description', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                decoration: inputDecoration('Add Medicine Description..'),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Disclaimer', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              TextFormField(
                decoration: inputDecoration('Add Disclaimer'),
                maxLines: 3,
                onSaved: (value) => _disclaimer = value,
              ),
              SizedBox(height: 16),

              Text('Medicine Status', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: inputDecoration('Select Status'),
                value: _status,
                items: ['Publish', 'Draft'].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                onChanged: (value) => setState(() => _status = value),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Medicine $_title added with status $_status')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  ),
                  child: Text('Update', style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
