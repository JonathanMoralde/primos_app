import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* Provider to hold the image URLs as state
final imageUrlProvider = StateProvider<Map<String, String>>((ref) {
  final imageUrls = ref.watch(imageUrlsProvider).value ?? {};
  return imageUrls;
});

// In your initialization code, like when your app starts or where you need to fetch the image URLs
// Future<void> fetchAndSetImageUrls(WidgetRef ref) async {
//   try {
//     final snapshot = await FirebaseFirestore.instance.collection('menu').get();
//     final imageUrls = <String, String>{};

//     for (final doc in snapshot.docs) {
//       final productId = doc.id;
//       final imageUrl = doc.get('imageURL') as String;
//       imageUrls[productId] = imageUrl;
//     }

//      ref.read(imageUrlProvider.notifier).state = imageUrls;
//   } catch (error) {
//     print('Error fetching image URLs: $error');
//   }
// }

//* Provider to fetch and return the image URLs as a future
final imageUrlsProvider = FutureProvider<Map<String, String>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('menu').get();
  final imageUrls = <String, String>{};

  for (final doc in snapshot.docs) {
    final productId = doc.id;
    final imageUrl = doc.get('imageURL') as String;
    imageUrls[productId] = imageUrl;
  }

  return imageUrls;
});

// final imageUrlsProvider = FutureProvider<Map<String, String>>((ref)=>{
//   try {
//     final snapshot = await FirebaseFirestore.instance.collection('menu').get();
//     final imageUrls = <String, String>{};

//     for (final doc in snapshot.docs) {
//       final productId = doc.id;
//       final imageUrl = doc.get('imageURL') as String;
//       imageUrls[productId] = imageUrl;
//     }

//     //  ref.read(imageUrlProvider.notifier).state = imageUrls;
//       return imageUrls;
//   } catch (error) {
//     print('Error fetching image URLs: $error');
//   }
// });

//* Provider to fetch and set the image URL
final fetchAndSetImageUrlsProvider = FutureProvider<void>((ref) async {
  try {
    await ref.read(imageUrlsProvider.future);
  } catch (error) {
    print('Error fetching image URLs: $error');
  }
});
