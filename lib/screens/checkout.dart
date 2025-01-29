import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int activeStep = 0;
  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 5;
  double progress = 0.2;
  Set<int> reachedSteps = <int>{0, 2, 4, 5};

  void increaseProgress() {
    if (progress < 1) {
      setState(() => progress += 0.2);
    } else {
      setState(() => progress = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          backgroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EasyStepper(
                  activeStep: activeStep2,
                  lineStyle: LineStyle(
                    lineLength: 100,
                    lineThickness: 6,
                    lineSpace: 4,
                    lineType: LineType.normal,
                    defaultLineColor: kSecondaryColor,
                    progress: progress,
                  ),
                  borderThickness: 10,
                  internalPadding: 15,
                  steps: [
                    EasyStep(
                        icon: const Icon(CupertinoIcons.cart),
                        title: 'Cart',
                        lineText: 'Add Address Info',
                        enabled: _allowTabStepping(0, StepEnabling.sequential)),
                    EasyStep(
                      icon: Icon(CupertinoIcons.info),
                      title: 'Address',
                      lineText: 'Go To Checkout',
                    ),
                    EasyStep(
                      icon: Icon(CupertinoIcons.cart_fill_badge_plus),
                      title: 'Checkout',
                      lineText: 'Choose Payment Method',
                    ),
                    EasyStep(
                      icon: Icon(CupertinoIcons.money_dollar),
                      title: 'Payment',
                      lineText: 'Confirm Order Items',
                    ),
                    EasyStep(
                      icon: Icon(Icons.file_present_rounded),
                      title: 'Order Details',
                      lineText: 'Submit Order',
                    ),
                    EasyStep(
                      icon: Icon(Icons.check_circle_outline),
                      title: 'Finish',
                    ),
                  ],
                  onStepReached: (index) => setState(() => activeStep = index),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          children: [
            _previousStep(StepEnabling.individual),
            _nextStep(StepEnabling.sequential),
          ],
        ),
      ),
    );
  }

  bool _allowTabStepping(int index, StepEnabling enabling) {
    return enabling == StepEnabling.sequential
        ? index <= reachedStep
        : reachedSteps.contains(index);
  }

  /// Returns the next button.
  Widget _nextStep(StepEnabling enabling) {
    return IconButton(
      onPressed: () {
        if (activeStep2 < upperBound) {
          setState(() {
            if (enabling == StepEnabling.sequential) {
              ++activeStep2;
              if (reachedStep < activeStep2) {
                reachedStep = activeStep2;
              }
            } else {
              activeStep2 =
                  reachedSteps.firstWhere((element) => element > activeStep2);
            }
          });
        }
      },
      icon: const Icon(Icons.arrow_forward_ios),
    );
  }

  /// Returns the previous button.
  Widget _previousStep(StepEnabling enabling) {
    return IconButton(
      onPressed: () {
        if (activeStep2 > 0) {
          setState(() => enabling == StepEnabling.sequential
              ? --activeStep2
              : activeStep2 =
                  reachedSteps.lastWhere((element) => element < activeStep2));
        }
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }
}

enum StepEnabling { sequential, individual }
