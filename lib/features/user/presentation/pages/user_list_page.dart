import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_event.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_state.dart';
import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/user_list_tile.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/delete_user_dialog.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/empty_users_widget.dart';
import 'package:quantum_parking_flutter/features/user/presentation/widgets/create_user_dialog.dart';
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
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider.value(
      value: getIt<UserBloc>()..add(LoadUsers()),
      child: Scaffold(
      appBar: AppBar(
        title: Text(l10n.users),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateUserDialog(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.message != null) {
            String localizedMessage;
            switch (state.message) {
              case 'Users loaded successfully':
                localizedMessage = l10n.usersLoadedSuccessfully;
                break;
              case 'User created successfully':
                localizedMessage = l10n.userCreatedSuccessfully;
                break;
              case 'User updated successfully':
                localizedMessage = l10n.userUpdatedSuccessfully;
                break;
              case 'User deleted successfully':
                localizedMessage = l10n.userDeletedSuccessfully;
                break;
              case 'User status updated successfully':
                localizedMessage = l10n.userStatusUpdatedSuccessfully;
                break;
              default:
                localizedMessage = state.message!;
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizedMessage),
                backgroundColor: Colors.green,
              ),
            );
            context.read<UserBloc>().add(ClearUserMessage());
          }
          
          if (state.error != null) {
            String localizedError;
            if (state.error!.contains('Failed to create user')) {
              localizedError = l10n.failedToCreateUser;
            } else if (state.error!.contains('Failed to update user')) {
              localizedError = l10n.failedToUpdateUser;
            } else if (state.error!.contains('Failed to delete user')) {
              localizedError = l10n.failedToDeleteUser;
            } else if (state.error!.contains('Failed to load users')) {
              localizedError = l10n.failedToLoadUsers;
            } else if (state.error!.contains('Failed to get user')) {
              localizedError = l10n.failedToGetUser;
            } else if (state.error!.contains('Failed to get users')) {
              localizedError = l10n.failedToGetUsers;
            } else if (state.error!.contains('Failed to get users by role')) {
              localizedError = l10n.failedToGetUsersByRole;
            } else {
              localizedError = state.error!;
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizedError),
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

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateUserDialog(
          onCreateUser: (email, password) {
            getIt<UserBloc>().add(CreateUser(
              email: email,
              password: password,
            ));
          },
        );
      },
    );
  }
} 