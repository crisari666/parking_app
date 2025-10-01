# App Configuration Feature

This feature provides a complete solution for managing app configuration from the backend, including version checking and update prompts.

## Overview

The config feature follows SOLID principles and provides:
- Remote data source for fetching configuration from backend
- Local data source for caching configuration
- Repository pattern for data management
- BLoC pattern for state management
- Service layer for easy access to configuration values
- Automatic version checking and update prompts

## Architecture

```
lib/features/config/
├── data/
│   ├── datasources/
│   │   ├── config_remote_datasource.dart    # Backend API calls
│   │   └── config_local_datasource.dart     # Local storage
│   ├── models/
│   │   └── app_config_model.dart           # Hive model for config data
│   └── repositories/
│       └── config_repository.dart          # Repository implementation
├── domain/
│   └── services/
│       └── config_service.dart             # Service layer
└── presentation/
    ├── bloc/
    │   ├── config_bloc.dart                # BLoC for state management
    │   ├── config_event.dart               # Events
    │   └── config_state.dart               # States
    └── widgets/
        ├── update_dialog.dart              # Update prompt dialog
        └── config_info_widget.dart         # Example usage widget
```

## Usage

### 1. Basic Configuration Access

```dart
// Get the config service
final configService = getIt<ConfigService>();

// Get a specific config value
final appName = await configService.getConfigValue('app_name');

// Get minimum build number
final minBuild = await configService.getMinBuildNumber();

// Check if update is required
final isUpdateRequired = await configService.isUpdateRequired(currentBuildNumber);
```

### 2. Using the Config BLoC

```dart
// Check app version (automatically shows update dialog if needed)
context.read<ConfigBloc>().add(CheckAppVersion());

// Load app configuration
context.read<ConfigBloc>().add(LoadAppConfig());

// Refresh configuration from backend
context.read<ConfigBloc>().add(RefreshAppConfig());
```

### 3. Listening to Config States

```dart
BlocListener<ConfigBloc, ConfigState>(
  listener: (context, state) {
    if (state is UpdateRequired) {
      // Show update dialog
      showDialog(
        context: context,
        builder: (context) => UpdateDialog(
          currentVersion: state.currentVersion,
          minRequiredVersion: state.minRequiredVersion,
          storeUrl: state.storeUrl,
        ),
      );
    }
  },
  child: YourWidget(),
)
```

## API Endpoint

The feature expects the following API endpoint:

```
GET {{BASE_URL}}/config
```

Response format:
```json
[
  {
    "_id": "681bfbfed2c1a847aca7befc",
    "key": "app_name",
    "value": "Quantum Parking",
    "createdAt": "2025-05-08T00:34:06.944Z",
    "updatedAt": "2025-05-08T00:35:00.696Z",
    "__v": 0
  },
  {
    "_id": "681bfc34d2c1a847aca7beff",
    "key": "min_build_number",
    "value": "1",
    "createdAt": "2025-05-08T00:35:00.696Z",
    "updatedAt": "2025-05-08T00:35:00.696Z",
    "__v": 0
  }
]
```

## Key Configuration Values

- `app_name`: The name of the application
- `min_build_number`: Minimum required build number for the app

## Version Checking

The feature automatically checks the app version on startup and compares it with the `min_build_number` from the backend. If the current version is lower than the required version, it shows an update dialog that redirects users to the appropriate app store.

## Dependencies

Make sure to add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  package_info_plus: ^8.0.2
  url_launcher: ^6.2.5
```

## Integration

The feature is automatically integrated into the app through dependency injection. The config checking is triggered on the login page, and the update dialog is handled globally in the main app widget. 