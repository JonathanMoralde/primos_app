// functions/index.js

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  try {
    // Ensure the user is authenticated and authorized to perform deletion
    if (!context.auth || !context.auth.token.admin) {
      throw new functions.https.HttpsError('permission-denied', 'Unauthorized.');
    }

    const userId = data.userId;

    // Delete user from Firebase Authentication
    await admin.auth().deleteUser(userId);
    console.log(`User ${userId} deleted from Firebase Authentication.`);

    // Delete user document from Firestore
    await admin.firestore().collection('users').doc(userId).delete();
    console.log(`User document ${userId} deleted from Firestore.`);

    return { message: 'User deleted successfully.' };
  } catch (error) {
    console.error('Error deleting user:', error);
    throw new functions.https.HttpsError('internal', 'Error deleting user.');
  }
});
