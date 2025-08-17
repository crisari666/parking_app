import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_event.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_state.dart';

class UserMembershipForm extends StatefulWidget {
  const UserMembershipForm({super.key});

  @override
  State<UserMembershipForm> createState() => _UserMembershipFormState();
}

class _UserMembershipFormState extends State<UserMembershipForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<UserMembershipBloc>().add(
        CreateUserMembership(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        ),
      );
      
      // Clear form after submission
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocListener<UserMembershipBloc, UserMembershipState>(
      listener: (context, state) {
        if (state.isMembershipCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? l10n.userMembershipCreatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          context.read<UserMembershipBloc>().add(ClearUserMembershipMessage());
        }
        
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<UserMembershipBloc>().add(ClearUserMembershipMessage());
        }
      },
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.createUserMembership,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.fullName,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterAName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterAnEmail;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return l10n.pleaseEnterAValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterAPhoneNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<UserMembershipBloc, UserMembershipState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isLoading ? null : _submitForm,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.createMembership),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 