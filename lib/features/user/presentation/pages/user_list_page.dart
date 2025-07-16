import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_event.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_state.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';

@RoutePage()
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<UserBloc>();
        bloc.add(LoadUsers());
        return bloc;
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create user page
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Colors.green,
              ),
            );
            context.read<UserBloc>().add(ClearUserMessage());
          }
          
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<UserBloc>().add(ClearUserMessage());
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.users.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return UserListTile(
                user: user,
                onTap: () {
                  context.read<UserBloc>().add(SelectUser(user));
                  // TODO: Navigate to user details page
                },
                onToggleStatus: (isActive) {
                  context.read<UserBloc>().add(ToggleUserStatus(user.id, isActive));
                },
                onDelete: () {
                  _showDeleteConfirmation(context, user);
                },
              );
            },
          );
        },
      ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<UserBloc>().add(DeleteUser(user.id));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class UserListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final Function(bool) onToggleStatus;
  final VoidCallback onDelete;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name[0].toUpperCase()),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: user.isActive,
            onChanged: onToggleStatus,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
} 