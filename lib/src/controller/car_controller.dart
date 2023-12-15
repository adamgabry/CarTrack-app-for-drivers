import 'package:flutter/foundation.dart';
import 'package:itu_cartrack/src/controller/login_controller.dart';
import 'package:itu_cartrack/src/model/car_model.dart';
import 'package:itu_cartrack/src/model/car.dart';
import 'package:itu_cartrack/src/model/ride.dart';

class CarController {
  static final CarController _instance = CarController._internal();
  static Car activeCar = Car();
  static Ride activeRide = Ride();
  static final CarModel carModel = CarModel();
  static Function? onOdometerChange; // Callback function

  factory CarController() {
    return _instance;
  }

  CarController._internal();

  static updateOdometer(int newOdometer) {
    activeCar.odometerStatus = newOdometer.toString();
    onOdometerChange?.call(); // Trigger the callback
  }

  Stream<List<Car>> get cars => carModel.getCars();

  Future<void> addCar(String name) async {
    // TODO: implement addCar
    Car newCar = Car();
    await carModel.addCar(newCar);
  }

  Future<void> deleteCar(String carId) async {
    await carModel.deleteCar(carId);
    carModel.getCars();
  }

  void setActiveCar(Car car) {
    activeCar = car;
  }

  Car getActiveCar() {
    return activeCar;
  }

  static void startRide() {
    activeRide.startedAt = DateTime.now();
  }

  static void finishRide() {
    activeRide.finishedAt = DateTime.now();
  }

  static bool isCorrectRideInput({required int odometerStatus, required String rideType}) {
    print('Ride finished!  ${rideType}, ${odometerStatus} <- ${activeCar.odometerStatus}');
    int odometerStatusInt = int.parse(activeCar.odometerStatus);

    if (odometerStatus > int.parse(activeCar.odometerStatus) &&
        rideType.isNotEmpty) {
      // update car
      activeCar.odometerStatus = odometerStatus.toString();
      carModel.saveCar(activeCar);
      // create ride
      activeRide.rideType = rideType;
      activeRide.distance = odometerStatus - odometerStatusInt;
      activeRide.finishedAt = DateTime.now();
      activeRide.userId = LoginController().getActiveUser().id;
      activeRide.save(activeCar.id);
      updateOdometer(odometerStatus);
      return true;
    } else {
      print('Ride not finished!');
      return false;
    }
  }
}
