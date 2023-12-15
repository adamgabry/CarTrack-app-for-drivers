import 'package:firebase_database/firebase_database.dart';
import 'package:itu_cartrack/src/model/car.dart';

class CarModel {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  CarModel();

  Future<void> addCar(Car car) async {
    DatabaseReference carRef = databaseReference.child('cars').push();
    await carRef.child('detail').set(car.toMap());
  }

  Future<void> deleteCar(String carId) async {
    await databaseReference.child('cars').child(carId).remove();
  }

  Stream<List<Car>> getCars() {
    return databaseReference.child('cars').onValue.map((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Car> carsList = [];
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            var detail = value['detail'] as Map<Object?, Object?>?;
            if (detail != null && detail.isNotEmpty) {
              carsList.add(Car.fromMap(key, detail.cast<String, dynamic>()));
            }
          }
        });

        print(carsList);
        return carsList;
      }

      return [];
    });
  }
  
  Future<void> saveCar(Car car) async {
    // saves new if id is empty & updates if id is not empty
    if (car.id.isEmpty) {
      databaseReference.child('cars').push().child('detail').set(car.toMap());
    } else {
      databaseReference.child('cars').child(car.id).child('detail').set(car.toMap());
    }
  }
}
