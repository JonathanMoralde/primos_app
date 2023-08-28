import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';

class AddVariationForm extends StatefulWidget {
  final String productId;

  AddVariationForm({
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  State<AddVariationForm> createState() => _AddVariationFormState();
}

class _AddVariationFormState extends State<AddVariationForm> {
  final variationController = TextEditingController();
  List<String> variations = [];
  bool isConfirmButtonEnabled = false; // Add this variable

  void _resetUI() {
    setState(() {
      variationController.clear();
      variations.clear();
      isConfirmButtonEnabled = false; // Reset the button state
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  void _confirmVariations() async {
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('variations')
        .doc(widget.productId);

    // Fetch existing variations
    final existingData = await docRef.get();

    List<String> existingVariations = [];
    if (existingData.exists) {
      final dataMap = existingData.data() as Map<String, dynamic>;
      if (dataMap.containsKey('variations')) {
        existingVariations = List<String>.from(dataMap['variations']);
      }
    }

    if (existingVariations.isEmpty) {
      // No existing variations, perform an "add" operation
      await docRef.set({
        'variations': variations,
      });
    } else {
      // Merge new variations with existing variations and perform an "update" operation
      final mergedVariations = [...existingVariations, ...variations];
      await docRef.update({
        'variations': FieldValue.arrayUnion(variations),
      });
    }

    _resetUI();
    _showSnackBar('Variation/s added successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD VARIATION'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledTextField(
                controller: variationController,
                hintText: 'Add Variation',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    btnIcon: const Icon(Icons.add),
                    btnText: 'ADD',
                    onClick: () {
                      setState(() {
                        variations.add(variationController.text);
                        variationController.clear();
                        isConfirmButtonEnabled =
                            true; // Enable the "CONFIRM" button
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  StyledButton(
                    btnText: 'CONFIRM',
                    onClick: isConfirmButtonEnabled ? _confirmVariations : null,
                    // Disable the button if no variations added
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              if (variations.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Added Variations:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    for (var i = 0; i < variations.length; i++)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('${i + 1}. ${variations[i]}'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
