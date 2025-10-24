import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Quantum Parking'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @closure.
  ///
  /// In en, this message translates to:
  /// **'Closure'**
  String get closure;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @dontHaveAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get dontHaveAccountRegister;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @checkOutVehicle.
  ///
  /// In en, this message translates to:
  /// **'Check Out Vehicle'**
  String get checkOutVehicle;

  /// No description provided for @findVehicle.
  ///
  /// In en, this message translates to:
  /// **'Find Vehicle'**
  String get findVehicle;

  /// No description provided for @parkingTime.
  ///
  /// In en, this message translates to:
  /// **'Parking Time'**
  String get parkingTime;

  /// No description provided for @estimatedPayment.
  ///
  /// In en, this message translates to:
  /// **'Estimated Payment'**
  String get estimatedPayment;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @setupRequired.
  ///
  /// In en, this message translates to:
  /// **'Setup Required'**
  String get setupRequired;

  /// No description provided for @completeInitialSetup.
  ///
  /// In en, this message translates to:
  /// **'Please complete the initial setup before using the app.'**
  String get completeInitialSetup;

  /// No description provided for @goToSetup.
  ///
  /// In en, this message translates to:
  /// **'Go to Setup'**
  String get goToSetup;

  /// No description provided for @checkInVehicle.
  ///
  /// In en, this message translates to:
  /// **'Check In Vehicle'**
  String get checkInVehicle;

  /// No description provided for @vehicleRecords.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Records'**
  String get vehicleRecords;

  /// No description provided for @searchByPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by Plate Number'**
  String get searchByPlateNumber;

  /// No description provided for @noRecordsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No records available'**
  String get noRecordsAvailable;

  /// No description provided for @pastLogsFor.
  ///
  /// In en, this message translates to:
  /// **'Past Logs for {plateNumber}'**
  String pastLogsFor(Object plateNumber);

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get paymentMethodTransfer;

  /// No description provided for @vehicleTypeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get vehicleTypeCar;

  /// No description provided for @vehicleTypeMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get vehicleTypeMotorcycle;

  /// No description provided for @vehicleTypeTruck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get vehicleTypeTruck;

  /// No description provided for @vehicleTypeVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get vehicleTypeVan;

  /// No description provided for @stillParking.
  ///
  /// In en, this message translates to:
  /// **'Still Parking'**
  String get stillParking;

  /// No description provided for @vehicleCheckedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle checked in successfully'**
  String get vehicleCheckedInSuccess;

  /// No description provided for @dailyClosure.
  ///
  /// In en, this message translates to:
  /// **'Daily Closure'**
  String get dailyClosure;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummary;

  /// No description provided for @totalVehicles.
  ///
  /// In en, this message translates to:
  /// **'Total Vehicles'**
  String get totalVehicles;

  /// No description provided for @totalCars.
  ///
  /// In en, this message translates to:
  /// **'Total Cars'**
  String get totalCars;

  /// No description provided for @totalMotorcycles.
  ///
  /// In en, this message translates to:
  /// **'Total Motorcycles'**
  String get totalMotorcycles;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financialSummary;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @totalDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Total Discounts'**
  String get totalDiscounts;

  /// No description provided for @totalMemberships.
  ///
  /// In en, this message translates to:
  /// **'Total Memberships'**
  String get totalMemberships;

  /// No description provided for @netSales.
  ///
  /// In en, this message translates to:
  /// **'Net Sales'**
  String get netSales;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @currentClosureDetails.
  ///
  /// In en, this message translates to:
  /// **'Current Closure Details'**
  String get currentClosureDetails;

  /// No description provided for @vehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Plate'**
  String get vehiclePlate;

  /// No description provided for @paymentValue.
  ///
  /// In en, this message translates to:
  /// **'Payment Value'**
  String get paymentValue;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @businessBrand.
  ///
  /// In en, this message translates to:
  /// **'Business Brand'**
  String get businessBrand;

  /// No description provided for @carHourCost.
  ///
  /// In en, this message translates to:
  /// **'Car Hourly Cost'**
  String get carHourCost;

  /// No description provided for @motorcycleHourCost.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Hourly Cost'**
  String get motorcycleHourCost;

  /// No description provided for @carMonthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Car Monthly Cost'**
  String get carMonthlyCost;

  /// No description provided for @motorcycleMonthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Monthly Cost'**
  String get motorcycleMonthlyCost;

  /// No description provided for @setupSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Setup saved successfully!'**
  String get setupSavedSuccess;

  /// No description provided for @hourlyRates.
  ///
  /// In en, this message translates to:
  /// **'Tarifas por Hora'**
  String get hourlyRates;

  /// No description provided for @monthlyRates.
  ///
  /// In en, this message translates to:
  /// **'Tarifas Mensuales'**
  String get monthlyRates;

  /// No description provided for @carDayCost.
  ///
  /// In en, this message translates to:
  /// **'Car Daily Cost'**
  String get carDayCost;

  /// No description provided for @motorcycleDayCost.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Daily Cost'**
  String get motorcycleDayCost;

  /// No description provided for @printerSetup.
  ///
  /// In en, this message translates to:
  /// **'Printer Setup'**
  String get printerSetup;

  /// No description provided for @noPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'No paired devices found'**
  String get noPairedDevices;

  /// No description provided for @selectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Select Printer'**
  String get selectPrinter;

  /// No description provided for @refreshDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh Devices'**
  String get refreshDevices;

  /// No description provided for @disconnectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Printer'**
  String get disconnectPrinter;

  /// No description provided for @pressRefreshToScan.
  ///
  /// In en, this message translates to:
  /// **'Press refresh to scan for devices'**
  String get pressRefreshToScan;

  /// No description provided for @carNightCost.
  ///
  /// In en, this message translates to:
  /// **'Car Night Cost'**
  String get carNightCost;

  /// No description provided for @motorcycleNightCost.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Night Cost'**
  String get motorcycleNightCost;

  /// No description provided for @studentMotorcycleHourCost.
  ///
  /// In en, this message translates to:
  /// **'Student Motorcycle Hourly Cost'**
  String get studentMotorcycleHourCost;

  /// No description provided for @dailyRates.
  ///
  /// In en, this message translates to:
  /// **'Daily Rates'**
  String get dailyRates;

  /// No description provided for @nightRates.
  ///
  /// In en, this message translates to:
  /// **'Night Rates'**
  String get nightRates;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is required to continue. Please update to the latest version.'**
  String get updateRequiredMessage;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersion;

  /// No description provided for @minimumVersion.
  ///
  /// In en, this message translates to:
  /// **'Minimum Version'**
  String get minimumVersion;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @appConfiguration.
  ///
  /// In en, this message translates to:
  /// **'App Configuration'**
  String get appConfiguration;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan QR codes'**
  String get cameraPermissionRequired;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @pointCameraAtQRCode.
  ///
  /// In en, this message translates to:
  /// **'Point camera at QR code to scan'**
  String get pointCameraAtQRCode;

  /// No description provided for @printerConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer Connected'**
  String get printerConnected;

  /// No description provided for @printerDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Printer Disconnected'**
  String get printerDisconnected;

  /// No description provided for @businessData.
  ///
  /// In en, this message translates to:
  /// **'Business Data'**
  String get businessData;

  /// No description provided for @rates.
  ///
  /// In en, this message translates to:
  /// **'Rates'**
  String get rates;

  /// No description provided for @businessNit.
  ///
  /// In en, this message translates to:
  /// **'Business NIT'**
  String get businessNit;

  /// No description provided for @businessResolution.
  ///
  /// In en, this message translates to:
  /// **'Business Resolution'**
  String get businessResolution;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @createNewUser.
  ///
  /// In en, this message translates to:
  /// **'Create New User'**
  String get createNewUser;

  /// No description provided for @enterUserEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter user email'**
  String get enterUserEmail;

  /// No description provided for @enterUserPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter user password'**
  String get enterUserPassword;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @pleaseEnterAnEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get pleaseEnterAnEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @pleaseEnterAPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterAPassword;

  /// No description provided for @userCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccessfully;

  /// No description provided for @userUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccessfully;

  /// No description provided for @userDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccessfully;

  /// No description provided for @userStatusUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User status updated successfully'**
  String get userStatusUpdatedSuccessfully;

  /// No description provided for @usersLoadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Users loaded successfully'**
  String get usersLoadedSuccessfully;

  /// No description provided for @failedToCreateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user'**
  String get failedToCreateUser;

  /// No description provided for @failedToUpdateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to update user'**
  String get failedToUpdateUser;

  /// No description provided for @failedToDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete user'**
  String get failedToDeleteUser;

  /// No description provided for @failedToLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get failedToLoadUsers;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @areYouSureYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {user}?'**
  String areYouSureYouWantToDelete(Object user);

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @failedToGetUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to get user'**
  String get failedToGetUser;

  /// No description provided for @failedToGetUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to get users'**
  String get failedToGetUsers;

  /// No description provided for @failedToGetUsersByRole.
  ///
  /// In en, this message translates to:
  /// **'Failed to get users by role'**
  String get failedToGetUsersByRole;

  /// No description provided for @cannotDisableOwnAccount.
  ///
  /// In en, this message translates to:
  /// **'You cannot disable your own account'**
  String get cannotDisableOwnAccount;

  /// No description provided for @failedToToggleUserStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle user status'**
  String get failedToToggleUserStatus;

  /// No description provided for @youAreLoggedInAsWorker.
  ///
  /// In en, this message translates to:
  /// **'You are logged in as a worker. You can view the setup but cannot modify it.'**
  String get youAreLoggedInAsWorker;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @printCheckOutReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print check-out receipt'**
  String get printCheckOutReceipt;

  /// No description provided for @noUserMembershipsFound.
  ///
  /// In en, this message translates to:
  /// **'No user memberships found'**
  String get noUserMembershipsFound;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @deleteMembership.
  ///
  /// In en, this message translates to:
  /// **'Delete Membership'**
  String get deleteMembership;

  /// No description provided for @areYouSureYouWantToDeleteMembership.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String areYouSureYouWantToDeleteMembership(Object name);

  /// No description provided for @userMemberships.
  ///
  /// In en, this message translates to:
  /// **'User Memberships'**
  String get userMemberships;

  /// No description provided for @existingMemberships.
  ///
  /// In en, this message translates to:
  /// **'Existing Memberships'**
  String get existingMemberships;

  /// No description provided for @createUserMembership.
  ///
  /// In en, this message translates to:
  /// **'Create User Membership'**
  String get createUserMembership;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @pleaseEnterAName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterAName;

  /// No description provided for @pleaseEnterAPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get pleaseEnterAPhoneNumber;

  /// No description provided for @createMembership.
  ///
  /// In en, this message translates to:
  /// **'Create Membership'**
  String get createMembership;

  /// No description provided for @findMemberships.
  ///
  /// In en, this message translates to:
  /// **'Find Memberships'**
  String get findMemberships;

  /// No description provided for @userMembershipCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User membership created successfully'**
  String get userMembershipCreatedSuccessfully;

  /// No description provided for @userMembershipsLoadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User memberships loaded successfully'**
  String get userMembershipsLoadedSuccessfully;

  /// No description provided for @userMembershipUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User membership updated successfully'**
  String get userMembershipUpdatedSuccessfully;

  /// No description provided for @userMembershipDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User membership deleted successfully'**
  String get userMembershipDeletedSuccessfully;

  /// No description provided for @failedToGetUserMemberships.
  ///
  /// In en, this message translates to:
  /// **'Failed to get user memberships'**
  String get failedToGetUserMemberships;

  /// No description provided for @failedToCreateUserMembership.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user membership'**
  String get failedToCreateUserMembership;

  /// No description provided for @failedToUpdateUserMembership.
  ///
  /// In en, this message translates to:
  /// **'Failed to update user membership'**
  String get failedToUpdateUserMembership;

  /// No description provided for @failedToDeleteUserMembership.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete user membership'**
  String get failedToDeleteUserMembership;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get deleteAction;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @vehicleId.
  ///
  /// In en, this message translates to:
  /// **'Vehicle ID'**
  String get vehicleId;

  /// No description provided for @pleaseSelectStartAndEndDates.
  ///
  /// In en, this message translates to:
  /// **'Please select start and end dates'**
  String get pleaseSelectStartAndEndDates;

  /// No description provided for @pleaseEnterAPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a plate number'**
  String get pleaseEnterAPlateNumber;

  /// No description provided for @pleaseEnterACost.
  ///
  /// In en, this message translates to:
  /// **'Please enter a cost'**
  String get pleaseEnterACost;

  /// No description provided for @pleaseEnterAValidCost.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid cost'**
  String get pleaseEnterAValidCost;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A parking management system with local storage and cloud sync capabilities.'**
  String get appDescription;

  /// No description provided for @versionInformation.
  ///
  /// In en, this message translates to:
  /// **'Version Information'**
  String get versionInformation;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// No description provided for @developerInformation.
  ///
  /// In en, this message translates to:
  /// **'Developer Information'**
  String get developerInformation;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed By'**
  String get developedBy;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 Quantum Devs. All rights reserved.'**
  String get copyright;

  /// No description provided for @scanPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Scan Plate Number'**
  String get scanPlateNumber;

  /// No description provided for @tapToCapturePlate.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to capture a plate'**
  String get tapToCapturePlate;

  /// No description provided for @capturePlate.
  ///
  /// In en, this message translates to:
  /// **'Capture Plate'**
  String get capturePlate;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
