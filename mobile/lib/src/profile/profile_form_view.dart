import 'package:finny/src/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:finny/src/profile/profile_form.dart';
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
  bool _isLoading = true;
  late Profile _profile;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final profile = await widget.onboardingController.getProfile();
      setState(() {
        _profile = profile;
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ProfileForm(
                  initialDateOfBirth: _profile.dateOfBirth,
                  initialRetirementAge: _profile.retirementAge,
                  initialRiskProfile:
                      _profile.riskProfile ?? RiskProfile.balanced,
                  initialFireProfile:
                      _profile.fireProfile ?? FireProfile.traditional,
                  onSubmit: _updateProfile,
                ),
              ),
      ),
    );
  }

  Future<void> _updateProfile(ProfileUpdateInput input) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onboardingController.updateProfile(input);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
