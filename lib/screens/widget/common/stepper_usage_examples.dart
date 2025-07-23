import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/reusable_stepper_widget.dart';
import 'package:zed_nano/screens/widget/common/stepper_step_page.dart';
import 'package:zed_nano/utils/Colors.dart';

/// Example implementations showing different ways to use the ReusableStepperWidget

// Example 1: Basic stepper with simple steps
class BasicStepperExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReusableStepperWidget(
      steps: [
        StepperStepPage(
          title: "Step 1",
          subtitle: "Enter your basic information",
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        StepperStepPage(
          title: "Step 2",
          subtitle: "Review your information",
          child: Center(
            child: Text(
              "Review your details here",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
      onCompleted: () {
        // Handle completion
        print("Stepper completed!");
      },
      onCancelled: () {
        // Handle cancellation
        print("Stepper cancelled!");
      },
    );
  }
}

// Example 2: Numbered stepper with custom styling
class NumberedStepperExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReusableStepperWidget(
      showStepNumbers: true,
      stepTitles: const [
        "Personal Info",
        "Address",
        "Confirmation",
      ],
      activeStepColor: Colors.blue,
      inactiveStepColor: Colors.grey[300],
      steps: [
        StepperStepPage(
          title: "Personal Information",
          child: _buildPersonalInfoForm(),
        ),
        StepperStepPage(
          title: "Address Details",
          child: _buildAddressForm(),
        ),
        StepperStepPage(
          title: "Confirmation",
          child: _buildConfirmationView(),
          nextButtonText: "Submit",
        ),
      ],
      onStepChanged: (step) {
        print("Moved to step: $step");
      },
      onCompleted: () {
        print("Form submitted!");
      },
    );
  }

  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "First Name",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: "Last Name",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Street Address",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: "City",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            "Please review your information",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

// Example 3: Custom step page with validation
class CustomStepExample extends StatefulWidget {
  @override
  _CustomStepExampleState createState() => _CustomStepExampleState();
}

class _CustomStepExampleState extends State<CustomStepExample> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StepperStepPage(
      title: "Enter Your Name",
      subtitle: "This information is required to proceed",
      canProceed: () => _formKey.currentState?.validate() ?? false,
      nextButtonEnabled: _name.isNotEmpty,
      isLoading: _isLoading,
      onNext: _handleNext,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Full Name *",
                border: OutlineInputBorder(),
                helperText: "Enter your full name as it appears on your ID",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Your name will be used for identification purposes",
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Proceed to next step
      StepperController.nextStep(context);
    }
  }
}

// Example 4: Stepper with custom buttons and actions
class CustomButtonStepperExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReusableStepperWidget(
      steps: [
        StepperStepPage(
          title: "Choose Options",
          child: _buildOptionsView(),
          customNextButton: _buildCustomNextButton(context),
          additionalActions: [
            TextButton.icon(
              onPressed: () {
                // Skip action
                StepperController.goToStep(context, 2);
              },
              icon: Icon(Icons.skip_next),
              label: Text("Skip this step"),
            ),
          ],
        ),
        StepperStepPage(
          title: "Upload Files",
          child: _buildUploadView(),
          showPreviousButton: false, // Hide previous button
          customNextButton: _buildUploadButton(context),
        ),
        StepperStepPage(
          title: "Complete",
          child: _buildCompleteView(),
          showNextButton: false, // Hide next button
          customPreviousButton: _buildCustomBackButton(context),
          additionalActions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Custom completion action
                  Navigator.of(context).pop();
                },
                child: Text("Finish"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsView() {
    return Column(
      children: [
        CheckboxListTile(
          title: Text("Option 1"),
          value: true,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text("Option 2"),
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildUploadView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload, size: 64),
          SizedBox(height: 16),
          Text("Drag and drop files here"),
        ],
      ),
    );
  }

  Widget _buildCompleteView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text("All done!", style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildCustomNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => StepperController.nextStep(context),
        icon: Icon(Icons.arrow_forward),
        label: Text("Continue"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => StepperController.nextStep(context),
        icon: Icon(Icons.upload),
        label: Text("Upload & Continue"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCustomBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => StepperController.previousStep(context),
        icon: Icon(Icons.arrow_back),
        label: Text("Go Back"),
      ),
    );
  }
}
