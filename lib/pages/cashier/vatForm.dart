import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:primos_app/providers/cashier/vatPercentage_provider.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';

class VatForm extends ConsumerWidget {
  VatForm({super.key});

  final vatController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> updateOrAddDataToFirestore(int percentage) async {
      try {
        // Reference the VAT document using its ID
        final vatDocumentReference =
            FirebaseFirestore.instance.collection('vat').doc('percentage');

        // Check if the document already exists
        final vatDocumentSnapshot = await vatDocumentReference.get();

        if (vatDocumentSnapshot.exists) {
          // If the document exists, update the "percentage" field
          await vatDocumentReference
              .update({'percentage': percentage}).then((value) {
            ref.refresh(vatPercentageProvider);
            Fluttertoast.showToast(msg: "Percentage changed successfully!");
            vatController.clear();
          });
          print('Data updated in Firestore successfully');
        } else {
          // If the document doesn't exist, create a new one
          await vatDocumentReference
              .set({'percentage': percentage}).then((value) {
            ref.refresh(vatPercentageProvider);
            Fluttertoast.showToast(msg: "Percentage added!");
            vatController.clear();
          });
          print('Data added to Firestore successfully');
        }
      } catch (e) {
        print('Error updating/adding data to Firestore: $e');
      }
    }

    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("CHANGE VAT %"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledTextField(
                  keyboardType: TextInputType.number,
                  controller: vatController,
                  hintText: "Enter Percentage",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              StyledButton(
                btnText: "CONFIRM",
                onClick: () {
                  if (vatController.text.isNotEmpty) {
                    updateOrAddDataToFirestore(int.parse(vatController.text));
                  } else {
                    Fluttertoast.showToast(msg: "Please enter the percentage");
                  }
                },
                btnWidth: 250,
              )
            ],
          ),
        ),
      ),
    );
  }
}
