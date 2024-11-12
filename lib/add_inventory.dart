import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInventoryPage extends StatefulWidget {
  final String? docId;
  final String? currentName;
  final int? currentQuantity;

  AddInventoryPage({this.docId, this.currentName, this.currentQuantity});

  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  late String _itemName;
  late int _itemQuantity;

  @override
  void initState() {
    super.initState();
    _itemName = widget.currentName ?? '';
    _itemQuantity = widget.currentQuantity ?? 0;
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final itemData = {
        'name': _itemName,
        'quantity': _itemQuantity,
      };

      if (widget.docId != null) {
        FirebaseFirestore.instance
            .collection('inventory')
            .doc(widget.docId)
            .update(itemData);
      } else {
        FirebaseFirestore.instance.collection('inventory').add(itemData);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docId == null ? 'Add Inventory Item' : 'Edit Inventory Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _itemName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter name';
                  }
                  return null;
                },
                onSaved: (value) => _itemName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _itemQuantity.toString(),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
                onSaved: (value) => _itemQuantity = int.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: Text(widget.docId == null ? 'Add to Inventory' : 'Update Inventory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
