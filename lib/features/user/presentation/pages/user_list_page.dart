import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_event.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_state.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/user_list_tile.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/delete_user_dialog.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/empty_users_widget.dart';
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
    return BlocProvider.value(
      value: getIt<UserBloc>()..add(LoadUsers()),
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
            return const EmptyUsersWidget();
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
        return DeleteUserDialog(
          user: user,
          onConfirm: () {
            context.read<UserBloc>().add(DeleteUser(user.id));
          },
        );
      },
    );
  }
} 