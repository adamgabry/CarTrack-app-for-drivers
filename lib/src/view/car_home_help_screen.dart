/// contains the help screen for the car home page, which shows the user option to call the assistance service in the event of an accident
/// @Author: Adam Gabrys xgabry01

import 'package:flutter/material.dart';
import 'package:itu_cartrack/src/controller/car_controller.dart';
import 'package:itu_cartrack/src/model/car.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCallPage extends StatefulWidget {
  @override
  _HelpCallPageState createState() => _HelpCallPageState();
}

class _HelpCallPageState extends State<HelpCallPage> {
  final Car selectedCar = CarController.activeCar;
  double _slideValue = 0.28;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Set the slider width to be 85% of the screen width
    final double _sliderWidth = screenWidth * 0.85;
    final double _sliderHeight = screenHeight * 0.12;

    return Scaffold(
      appBar: AppBar(
        title: Text('Call Assistance Service',
            style: TextStyle(color: theme.colorScheme.onSecondary)),
        backgroundColor: theme.colorScheme.secondary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.0),
              Icon(Icons.record_voice_over,
                  color: theme.colorScheme.secondary,
                  size: screenHeight * 0.085),
              SizedBox(height: 70.0),
              Text(
                'In the event of an accident\ncall assistance service:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 70.0),
              Text(
                'NONSTOP',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 70.0),
              Text(
                'Number: ' + selectedCar.insuranceContact,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // Update the slider value only if the drag is to the right
                  if (details.primaryDelta! > 0) {
                    double newSlideValue =
                        _slideValue + details.primaryDelta! / _sliderWidth;
                    newSlideValue = newSlideValue.clamp(0.0, 1.0);

                    setState(() {
                      _slideValue = newSlideValue;
                    });

                    // If the slider reaches the end, make the call
                    if (_slideValue == 1.0) {
                      CarController().makePhoneCall(selectedCar
                          .insuranceContact);
                    }
                  }
                },
                onHorizontalDragEnd: (details) {
                  // Reset the slider when user stops dragging
                  setState(() {
                    _slideValue = 0.28;
                  });
                },
                child: Container(
                  height: _sliderHeight,
                  width: _sliderWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        width: _slideValue * _sliderWidth,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        alignment: Alignment.center,
                        // Center the icon inside the animated container
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: (1 - _slideValue).clamp(0.0, 1.0),
                          child: Text('slide to call'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
