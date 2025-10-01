# User Feature

This feature handles user management operations following the clean architecture pattern.

## Structure

```
user/
├── data/
│   ├── datasources/
│   │   └── user_remote_datasource.dart
│   ├── models/
│   │   └── user_data_model.dart
│   └── repositories/
│       └── user_repository_impl.dart
├── domain/
│   ├── entities/
│   ├── models/
│   │   └── user_model.dart
│   ├── repositories/
│   │   └── user_repository.dart
│   └── usecases/
├── presentation/
│   ├── bloc/
│   │   ├── user_bloc.dart
│   │   ├── user_event.dart
│   │   └── user_state.dart
│   ├── pages/
│   │   └── user_list_page.dart
│   └── widgets/
└── README.md
```

## Components

### Domain Layer
- **UserModel**: Core user entity with properties like id, name, email, role, etc.
- **UserRepository**: Abstract interface defining user operations

### Data Layer
- **UserDataModel**: Data layer model extending UserModel with JSON serialization
- **UserRemoteDataSource**: Handles API communication for user operations
- **UserRepositoryImpl**: Implementation of UserRepository interface

### Presentation Layer
- **UserBloc**: Manages user state and business logic
- **UserEvent**: Events for user operations (LoadUsers, CreateUser, UpdateUser, etc.)
- **UserState**: State class with copyWith method (avoiding sealed classes)
- **UserListPage**: Main page for displaying and managing users

## Features

- Load and display users
- Create new users
- Update existing users
- Delete users
- Toggle user active status
- User selection and management

## Usage

The UserBloc uses private methods for business logic as requested:
- `_onLoadUsers`: Handles loading users from repository
- `_onCreateUser`: Handles user creation
- `_onUpdateUser`: Handles user updates
- `_onDeleteUser`: Handles user deletion
- `_onToggleUserStatus`: Handles user status changes
- `_onSelectUser`: Handles user selection
- `_onClearUserMessage`: Handles message clearing

All state changes use the copyWith method for immutable state management. 