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
  final varPriceController = TextEditingController();
  List<String> variations = [];
  List<String> prices = [];
  bool isConfirmButtonEnabled = false; // Add this variable
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('variations')
        .doc(widget.productId);

    // Fetch existing variations
    final existingData = await docRef.get();

    List<String> existingVariations = [];
    List<String> existingPrices = []; // Add a list for existing prices
    if (existingData.exists) {
      final dataMap = existingData.data() as Map<String, dynamic>;
      if (dataMap.containsKey('variations')) {
        existingVariations = List<String>.from(dataMap['variations']);
      }
      if (dataMap.containsKey('prices')) {
        existingPrices = List<String>.from(dataMap['prices']);
      }
    }

    if (existingVariations.isEmpty && existingPrices.isEmpty) {
      // No existing variations, perform an "add" operation
      await docRef.set({
        'variations': variations,
        'prices': prices,
      });
    } else {
      // Merge new variations with existing variations and perform an "update" operation
      final mergedVariations = [...existingVariations, ...variations];
      final mergedPrices = [...existingPrices, ...prices];
      await docRef.update({
        'variations': FieldValue.arrayUnion(variations),
        'prices': FieldValue.arrayUnion(prices),
      });
    }
    setState(() {
      isLoading = false;
    });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledTextField(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    width: 200,
                    controller: variationController,
                    hintText: 'Add Variation',
                    obscureText: false,
                  ),
                  StyledButton(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    noShadow: true,
                    btnIcon: const Icon(Icons.add),
                    btnText: 'ADD',
                    onClick: () {
                      setState(() {
                        variations.add(variationController.text);
                        variationController.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledTextField(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    width: 200,
                    controller: varPriceController,
                    hintText: 'Add Variation Price',
                    obscureText: false,
                    keyboardType: TextInputType.number,
                  ),
                  StyledButton(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    noShadow: true,
                    btnIcon: const Icon(Icons.add),
                    btnText: 'ADD',
                    onClick: () {
                      setState(() {
                        prices.add(varPriceController.text);
                        varPriceController.clear();
                        isConfirmButtonEnabled =
                            true; // Enable the "CONFIRM" button
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Show circular progress indicator when isLoading is true
              if (isLoading)
                CircularProgressIndicator(), // Add a circular progress indicator

              // Show the button only when not loading
              if (!isLoading)
                StyledButton(
                  btnText: 'CONFIRM',
                  onClick: isConfirmButtonEnabled ? _confirmVariations : null,
                  // Disable the button if no variations added
                ),

              const SizedBox(height: 10),
              if (variations.isNotEmpty &&
                  prices.isNotEmpty &&
                  variations.length == prices.length)
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
                        child: Text(
                            '${i + 1}. ${variations[i]} - PHP ${prices[i]}'),
                      ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                  ),
                  SizedBox(
                      width: 4), // Adding a small gap between the icon and text
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Enter price at the same order as you've entered variation.",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
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
