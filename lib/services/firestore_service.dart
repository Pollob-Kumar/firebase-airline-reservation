import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/flight_model.dart';
import '../models/booking_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Operations
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  Future<void> updateBalance(String uid, double newBalance) async {
    await _db.collection('users').doc(uid).update({'balance': newBalance});
  }

  // Flight Operations
  Future<void> addFlight(FlightModel flight) async {
    await _db.collection('flights').add(flight.toMap());
  }

  Stream<List<FlightModel>> getFlights() {
    return _db.collection('flights').orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => FlightModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<void> deleteFlight(String flightId) async {
    await _db.collection('flights').doc(flightId).delete();
  }

  Future<void> updateFlightSeats(String flightId, int newAvailableSeats) async {
    await _db.collection('flights').doc(flightId).update({
      'availableSeats': newAvailableSeats,
    });
  }

  // Booking Operations
  Future<void> createBooking(BookingModel booking) async {
    await _db.collection('bookings').add(booking.toMap());
  }

  Stream<List<BookingModel>> getAllBookings() {
    return _db.collection('bookings').orderBy('bookingDate', descending: true).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}