import 'package:get/get.dart';

class RideModel {
  final String name;
  final String duration;
  final String fare;

  RideModel({required this.name, required this.duration, required this.fare});
}

class DriverHistoryLogic extends GetxController {
  final rides = <RideModel>[
    RideModel(name: 'Asad', duration: '20 minutes', fare: 'PKR.300'),
    RideModel(name: 'Ahsan', duration: '15 minutes', fare: 'PKR.250'),
    RideModel(name: 'Sara', duration: '30 minutes', fare: 'PKR.500'),
    RideModel(name: 'Ali', duration: '25 minutes', fare: 'PKR.400'),
    RideModel(name: 'Zara', duration: '10 minutes', fare: 'PKR.150'),
    RideModel(name: 'Zara', duration: '10 minutes', fare: 'PKR.150'),
    RideModel(name: 'Asad', duration: '20 minutes', fare: 'PKR.300'),
    RideModel(name: 'Ahsan', duration: '15 minutes', fare: 'PKR.250'),
    RideModel(name: 'Sara', duration: '30 minutes', fare: 'PKR.500'),
    RideModel(name: 'Ali', duration: '25 minutes', fare: 'PKR.400'),
    RideModel(name: 'Zara', duration: '10 minutes', fare: 'PKR.150'),
    RideModel(name: 'Zara', duration: '10 minutes', fare: 'PKR.150'),
  ].obs;
}
