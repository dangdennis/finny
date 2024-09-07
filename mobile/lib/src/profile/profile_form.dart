import 'package:finny/src/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:intl/intl.dart';

class ProfileForm extends StatefulWidget {
  final DateTime? initialDateOfBirth;
  final int? initialRetirementAge;
  final RiskProfile? initialRiskProfile;
  final FireProfile initialFireProfile;
  final Function(ProfileUpdateInput) onSubmit;

  const ProfileForm({
    super.key,
    this.initialDateOfBirth,
    this.initialRetirementAge,
    this.initialRiskProfile,
    required this.initialFireProfile,
    required this.onSubmit,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime? _dateOfBirth;
  late int? _retirementAge;
  late RiskProfile? _riskProfile;
  late FireProfile _fireProfile;

  @override
  void initState() {
    super.initState();
    _dateOfBirth = widget.initialDateOfBirth;
    _retirementAge = widget.initialRetirementAge;
    _riskProfile = widget.initialRiskProfile;
    _fireProfile = widget.initialFireProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              int currentAge = DateTime.now().year - _dateOfBirth!.year;
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
            items: [FireProfile.traditional].map((FireProfile profile) {
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
                  onPressed: _submitForm,
                  child: const Text('Save Profile'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        ProfileUpdateInput(
          dateOfBirth: _dateOfBirth,
          retirementAge: _retirementAge,
          riskProfile: _riskProfile,
          fireProfile: _fireProfile,
        ),
      );
    }
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
        _retirementAge = null;
        _riskProfile = null;
      });
    }
  }
}
