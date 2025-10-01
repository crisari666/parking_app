# User Membership Feature

This feature handles user membership management with a form to capture user data including name, email, and phone number.

## Structure

```
user_membership/
├── data/
│   ├── datasources/
│   │   └── user_membership_remote_datasource.dart
│   └── repositories/
│       └── user_membership_repository_impl.dart
├── domain/
│   ├── models/
│   │   └── user_membership_model.dart
│   └── repositories/
│       └── user_membership_repository.dart
└── presentation/
    ├── bloc/
    │   ├── user_membership_bloc.dart
    │   ├── user_membership_event.dart
    │   └── user_membership_state.dart
    ├── pages/
    │   └── user_membership_page.dart
    └── widgets/
        ├── user_membership_form.dart
        └── user_membership_list.dart
```

## Features

- **Create User Membership**: Form to capture user data (name, email, phone number)
- **List User Memberships**: Display existing memberships with edit/delete options
- **Update User Membership**: Edit existing membership data
- **Delete User Membership**: Remove memberships with confirmation dialog

## API Endpoints

- `GET /user-memberships` - Get all user memberships
- `POST /user-memberships` - Create new user membership
- `PUT /user-memberships/{id}` - Update user membership
- `DELETE /user-memberships/{id}` - Delete user membership
- `GET /user-memberships/{id}` - Get specific user membership

## Usage

The feature is accessible via the route `/main/user-memberships` and includes:

1. **Form Section**: Input fields for name, email, and phone number with validation
2. **List Section**: Display of existing memberships with action buttons
3. **Real-time Updates**: Automatic refresh after create/update/delete operations
4. **Error Handling**: User-friendly error messages and loading states

## Dependencies

- `flutter_bloc` for state management
- `equatable` for value equality
- `dio` for HTTP requests (via ApiClient)
- `get_it` for dependency injection

## Integration

The feature is integrated into the main app through:

1. **Dependency Injection**: Registered in `lib/injection/injection.dart`
2. **Routing**: Added to `lib/routes/app_router.dart`
3. **Navigation**: Accessible from the main navigation menu 