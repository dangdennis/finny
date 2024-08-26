import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class ProfileFormView extends StatefulWidget {
  const ProfileFormView({
    super.key,
    required this.onboardingController,
  });

  final OnboardingController onboardingController;

  @override
  State<ProfileFormView> createState() => _ProfileFormViewState();
}

class _ProfileFormViewState extends State<ProfileFormView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dateOfBirth;
  int? _retirementAge;
  RiskProfile? _riskProfile = RiskProfile.balanced;
  FireProfile _fireProfile = FireProfile.traditional;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final profile = await widget.onboardingController.getProfile();
      setState(() {
        _dateOfBirth = profile.dateOfBirth;
        _retirementAge = profile.retirementAge;
        _riskProfile = profile.riskProfile ?? RiskProfile.balanced;
        _fireProfile = profile.fireProfile ?? FireProfile.traditional;
        _isLoading = false;
      });
    } catch (e) {
      Logger.root.warning('Error loading existing profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the keyboard when tapping outside of inputs
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date of Birth
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        controller: TextEditingController(
                          text: _dateOfBirth != null
                              ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
                              : '',
                        ),
                        validator: (value) {
                          if (_dateOfBirth == null) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Retirement Age
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Retirement Age',
                        ),
                        keyboardType: TextInputType.number,
                        enabled: _dateOfBirth != null,
                        initialValue: _retirementAge?.toString(),
                        onChanged: (value) {
                          setState(() {
                            _retirementAge = int.tryParse(value);
                          });
                        },
                        validator: (value) {
                          if (_dateOfBirth == null) {
                            return 'Please select your date of birth first';
                          }
                          if (value == null || value.isEmpty) {
                            return 'Please enter your retirement age';
                          }
                          int? age = int.tryParse(value);
                          int currentAge =
                              DateTime.now().year - _dateOfBirth!.year;
                          if (age == null || age <= currentAge || age > 110) {
                            return 'Please enter a valid age between ${currentAge + 1} and 110';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Risk Profile
                      DropdownButtonFormField<RiskProfile>(
                        decoration: const InputDecoration(
                          labelText: 'Risk Profile',
                        ),
                        value: _riskProfile,
                        items: RiskProfile.values.map((RiskProfile profile) {
                          return DropdownMenuItem<RiskProfile>(
                            value: profile,
                            child: Text(profile.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: _retirementAge != null
                            ? (RiskProfile? newValue) {
                                setState(() {
                                  _riskProfile = newValue;
                                });
                              }
                            : null,
                        validator: (value) {
                          if (_retirementAge == null) {
                            return 'Please enter your retirement age first';
                          }
                          if (value == null) {
                            return 'Please select a risk profile';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // FIRE Profile
                      DropdownButtonFormField<FireProfile>(
                        decoration: const InputDecoration(
                          labelText: 'FIRE Profile',
                        ),
                        value: _fireProfile,
                        items: [FireProfile.traditional]
                            .map((FireProfile profile) {
                          return DropdownMenuItem<FireProfile>(
                            value: profile,
                            child: Text(profile.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: null, // Disabled
                        hint: const Text('More FIRE profiles coming soon!'),
                      ),
                      const SizedBox(height: 32),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true; // Show loading indicator
                                  });

                                  try {
                                    await widget.onboardingController
                                        .updateProfile(
                                      ProfileUpdateInput(
                                        dateOfBirth: _dateOfBirth,
                                        retirementAge: _retirementAge,
                                        riskProfile: _riskProfile,
                                        fireProfile: _fireProfile,
                                      ),
                                    );

                                    // todo: learn why if i refetch, the date of birth is wrong
                                    // Refetch the profile after updating
                                    // await _loadExistingProfile();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Profile updated successfully')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error updating profile: ${e.toString()}')),
                                      );
                                    }
                                  } finally {
                                    setState(() {
                                      _isLoading =
                                          false; // Hide loading indicator
                                    });
                                  }
                                }
                              },
                              child: const Text('Save Profile'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _retirementAge = null; // Reset retirement age when date changes
        _riskProfile = null; // Reset risk profile when date changes
      });
    }
  }
}
