import 'package:flutter/material.dart';


class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  String? _imagePath;
  String? _title;
  String? _actualPrice;
  String? _originalPrice;
  String? _category;
  String? _quantity;
  bool? _requiresPrescription = false;
  String? _description;
  String? _disclaimer;
  String? _status = 'Publish';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Image'),
                onSaved: (value) => _imagePath = value,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medicine title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Actual Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an actual price';
                  }
                  return null;
                },
                onSaved: (value) => _actualPrice = value,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Original Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an original price';
                  }
                  return null;
                },
                onSaved: (value) => _originalPrice = value,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Category'),
                items: ['Dandruff', 'Pain relief', 'Vaccines', 'Allergies', 'Bacterial Infections']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Medicine Quantity Limit'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _quantity = value,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<bool>(
                decoration: InputDecoration(labelText: 'Medicine Required Prescription?'),
                items: [true, false]
                    .map((prescription) => DropdownMenuItem(
                          value: prescription,
                          child: Text(prescription ? 'Yes' : 'No'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _requiresPrescription = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Description'),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Disclaimer'),
                maxLines: 3,
                onSaved: (value) => _disclaimer = value,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Medicine Status'),
                items: ['Publish', 'Draft']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Medicine ${_title} added with status ${_status}')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text('Update', style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}