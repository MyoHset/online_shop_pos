import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

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
    Locale('my')
  ];

  /// Generic save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Generic retry button label
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get commonRetry;

  /// Generic search label or placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// Generic 'All' filter label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// Generic delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Generic edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// Generic add button label
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// Generic close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Generic back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Generic confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Generic OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Generic loading indicator label
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// Actions column or header
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commonActions;

  /// Status column or field
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// Date column or field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// Total summary label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// Subtotal summary label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get commonSubtotal;

  /// Discount summary or input label
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get commonDiscount;

  /// Tax summary label
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get commonTax;

  /// Notes input or field label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// Required field label
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// Optional field label
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// Affirmative confirmation response
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// Negative confirmation response
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// Sign out action label
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get commonSignOut;

  /// Confirmation message before signing out
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get commonSignOutConfirm;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String commonVersion(String version);

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonLanguageEn;

  /// Burmese language name
  ///
  /// In en, this message translates to:
  /// **'မြန်မာ (Unicode)'**
  String get commonLanguageMy;

  /// Empty search or filter state
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get commonNoResults;

  /// Generic empty state
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get commonNoData;

  /// Apply filter or action button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// Clear action button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// Select action button
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get commonSelect;

  /// Navigation label for Dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// Navigation label for Quick Sale
  ///
  /// In en, this message translates to:
  /// **'Quick Sale'**
  String get navQuickSale;

  /// Short navigation label for Quick Sale on compact screens
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get navQuickSaleShort;

  /// Navigation label for Orders
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// Navigation label for Products
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// Navigation label for Customers
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// Navigation label for Staff management
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// Navigation label for Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Navigation label for Browse for Customer mode
  ///
  /// In en, this message translates to:
  /// **'Browse for Customer'**
  String get navBrowseForCustomer;

  /// Navigation label for Present Mode
  ///
  /// In en, this message translates to:
  /// **'Present Mode'**
  String get navPresentMode;

  /// Drawer section header for Management
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get navManagement;

  /// Drawer section header for Main Navigation
  ///
  /// In en, this message translates to:
  /// **'Main Navigation'**
  String get navMainNavigation;

  /// Sign in button label and page title
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authLogin;

  /// Register shop button label and page title
  ///
  /// In en, this message translates to:
  /// **'Register Shop'**
  String get authRegisterShop;

  /// Email input field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// Password input field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// Confirm password input field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// Forgot password link label
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// Reset password page title and action
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// Shop name input label
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get authShopName;

  /// Owner / staff full name input label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// Phone number input field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhone;

  /// Subtitle on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in to your POS.'**
  String get authLoginSubtitle;

  /// Subtitle on register screen
  ///
  /// In en, this message translates to:
  /// **'Create a new shop and admin account.'**
  String get authRegisterSubtitle;

  /// Subtitle on forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link.'**
  String get authForgotPasswordSubtitle;

  /// Action to send reset link email
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// Link returning to sign in
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get authBackToLogin;

  /// Navigation prompt to switch from register to login
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get authAlreadyHaveAccount;

  /// Navigation prompt to switch from login to register
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get authDontHaveAccount;

  /// Confirmation message after password reset request
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email.'**
  String get authCheckEmailForReset;

  /// Snackbar message upon successful login
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get authLoginSuccess;

  /// Snackbar message upon successful shop registration
  ///
  /// In en, this message translates to:
  /// **'Shop registered successfully!'**
  String get authRegisterSuccess;

  /// Staff role Owner
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// Staff role Manager
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// Staff role Staff
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get roleStaff;

  /// Generic title for error states
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorSomethingWentWrong;

  /// Error message for invalid credentials
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get errorInvalidCredentials;

  /// Error message for unconfirmed email
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email before signing in.'**
  String get errorEmailNotConfirmed;

  /// Error message when email is already registered
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get errorUserAlreadyRegistered;

  /// Error message when password does not meet min length
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get errorPasswordTooShort;

  /// Error message when requested quantity exceeds stock
  ///
  /// In en, this message translates to:
  /// **'Insufficient stock available for this operation.'**
  String get errorInsufficientStock;

  /// Error message for 42501 or RLS violations
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get errorPermissionDenied;

  /// Error message for network failure
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// Error message when record does not exist
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get errorNotFound;

  /// Generic validation error message
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get errorValidation;

  /// Error message when discount exceeds staff allowance
  ///
  /// In en, this message translates to:
  /// **'Discount exceeds your allowed limit — ask a manager.'**
  String get errorDiscountExceedsLimit;

  /// Generic server failure message
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get errorServer;

  /// Fallback error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnknown;

  /// Error message when image upload fails
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image. Please try again.'**
  String get errorImageUpload;

  /// Error message when local storage/cache fails
  ///
  /// In en, this message translates to:
  /// **'Failed to access local cache.'**
  String get errorCache;

  /// Error message when loading list or detail data fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load data.'**
  String get errorFailedToLoadData;

  /// Validation message when field is left blank
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// Validation message for malformed email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationInvalidEmail;

  /// Validation message for minimum password length
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordLength;

  /// Validation message when confirmation password differs
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// Validation message for invalid phone format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validationInvalidPhone;

  /// Validation message for non-numeric input
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get validationInvalidNumber;

  /// Validation message when number must be positive
  ///
  /// In en, this message translates to:
  /// **'Value must be greater than 0'**
  String get validationPositiveNumber;

  /// Order status Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// Order status Confirmed
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// Order status Packed
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get orderStatusPacked;

  /// Order status Processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// Order status Shipped
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// Order status Delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// Order status Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// Order type In-Store
  ///
  /// In en, this message translates to:
  /// **'In-Store'**
  String get orderTypeInStore;

  /// Order type Online
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get orderTypeOnline;

  /// Order type Credit
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get orderTypeCredit;

  /// Orders list screen title
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orderListTitle;

  /// Order details screen title
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailTitle;

  /// Button to create a new order
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get orderCreateNew;

  /// Order header with ID
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderId(String id);

  /// Order items section header with count
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String orderItems(int count);

  /// Pluralized count of items in an order
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String orderItemCount(int count);

  /// Customer label in order view
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get orderCustomer;

  /// Order date field label
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDate;

  /// Total amount in order view
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get orderTotal;

  /// Payment status field in order view
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get orderPaymentStatus;

  /// Button to update order status
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get orderUpdateStatus;

  /// Dialog confirmation to cancel order
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get orderCancelConfirm;

  /// Snackbar message upon cancelling an order
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully'**
  String get orderCancelledSuccess;

  /// Snackbar message upon updating order status
  ///
  /// In en, this message translates to:
  /// **'Order status updated'**
  String get orderStatusUpdatedSuccess;

  /// Order filter tab for all orders
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get orderFilterAll;

  /// Order filter date preset Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get orderFilterToday;

  /// Order filter date preset Yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get orderFilterYesterday;

  /// Order filter date preset This Week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get orderFilterThisWeek;

  /// Order filter date preset This Month
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get orderFilterThisMonth;

  /// Order filter date preset Custom Date
  ///
  /// In en, this message translates to:
  /// **'Custom Date'**
  String get orderFilterCustomDate;

  /// Search field placeholder in orders list
  ///
  /// In en, this message translates to:
  /// **'Search by order # or customer...'**
  String get orderSearchPlaceholder;

  /// Empty state when no orders match
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get orderEmpty;

  /// Button to apply discount to order
  ///
  /// In en, this message translates to:
  /// **'Apply Discount'**
  String get orderApplyDiscount;

  /// Discount type selector
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get orderDiscountType;

  /// Discount value input label
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get orderDiscountAmount;

  /// Percentage discount label
  ///
  /// In en, this message translates to:
  /// **'Percentage (%)'**
  String get orderDiscountPercentage;

  /// Fixed amount discount label
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount (Ks)'**
  String get orderDiscountFixed;

  /// Snackbar message when discount is applied
  ///
  /// In en, this message translates to:
  /// **'Discount applied successfully'**
  String get orderDiscountApplied;

  /// Snackbar message after instant quick sale completion
  ///
  /// In en, this message translates to:
  /// **'Sale completed successfully!'**
  String get orderInstantSaleSuccess;

  /// Button to print receipt
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get orderPrintReceipt;

  /// DiscountType none
  ///
  /// In en, this message translates to:
  /// **'No Discount'**
  String get discountTypeNone;

  /// DiscountType percentage
  ///
  /// In en, this message translates to:
  /// **'Percentage (%)'**
  String get discountTypePercentage;

  /// DiscountType fixed amount
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount'**
  String get discountTypeFixed;

  /// Payment method Cash
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// Payment method KBZPay
  ///
  /// In en, this message translates to:
  /// **'KBZPay'**
  String get paymentMethodKbzpay;

  /// Payment method WavePay
  ///
  /// In en, this message translates to:
  /// **'WavePay'**
  String get paymentMethodWavepay;

  /// Payment method AYA Pay
  ///
  /// In en, this message translates to:
  /// **'AYA Pay'**
  String get paymentMethodApay;

  /// Payment method CB Pay
  ///
  /// In en, this message translates to:
  /// **'CB Pay'**
  String get paymentMethodCbpay;

  /// Payment method Bank Transfer
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentMethodBankTransfer;

  /// Payment method Cash on Delivery
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery (COD)'**
  String get paymentMethodCod;

  /// Payment method Credit
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get paymentMethodCredit;

  /// Payment status Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// Payment status Paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// Payment status Unpaid
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get paymentStatusUnpaid;

  /// Payment status Partially Paid
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get paymentStatusPartial;

  /// Payment status Refunded
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get paymentStatusRefunded;

  /// Payment entry screen title
  ///
  /// In en, this message translates to:
  /// **'Payment Entry'**
  String get paymentEntryTitle;

  /// Header for selecting payment method
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get paymentSelectMethod;

  /// Label for amount to pay
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmount;

  /// Label for amount tendered by customer
  ///
  /// In en, this message translates to:
  /// **'Amount Received'**
  String get paymentReceived;

  /// Label for change amount given back
  ///
  /// In en, this message translates to:
  /// **'Change Due'**
  String get paymentChange;

  /// Reference or slip number input label
  ///
  /// In en, this message translates to:
  /// **'Transaction / Slip ID'**
  String get paymentReference;

  /// Button to finalize payment
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get paymentComplete;

  /// Snackbar message upon successful payment entry
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully'**
  String get paymentSuccess;

  /// Button and screen title to add a new product
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get productAddNew;

  /// Button and screen title to edit a product
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get productEdit;

  /// Products list screen title
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productListTitle;

  /// Product details screen title
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailTitle;

  /// Product name field label
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// Product category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productCategory;

  /// Product brand field label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get productBrand;

  /// Product description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// Product selling price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get productPrice;

  /// Product cost price label
  ///
  /// In en, this message translates to:
  /// **'Cost Price'**
  String get productCostPrice;

  /// Product inventory stock label
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get productStock;

  /// Product SKU code label
  ///
  /// In en, this message translates to:
  /// **'SKU / Barcode'**
  String get productSku;

  /// Badge indicating product is available
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get productInStock;

  /// Badge indicating product is out of stock
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get productOutOfStock;

  /// Badge indicating low inventory
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get productLowStock;

  /// Stock count remaining label
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String productStockLeft(int count);

  /// Variants section header
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get productVariants;

  /// Button to add a variant
  ///
  /// In en, this message translates to:
  /// **'Add Variant'**
  String get productAddVariant;

  /// Button to edit a variant
  ///
  /// In en, this message translates to:
  /// **'Edit Variant'**
  String get productEditVariant;

  /// Product search input placeholder
  ///
  /// In en, this message translates to:
  /// **'Search products by name, SKU...'**
  String get productSearchPlaceholder;

  /// Empty state when no products match
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get productEmpty;

  /// Snackbar message upon creating a product
  ///
  /// In en, this message translates to:
  /// **'Product created successfully'**
  String get productCreatedSuccess;

  /// Snackbar message upon updating a product
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccess;

  /// Snackbar message upon deleting a product
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccess;

  /// Confirmation dialog message before deleting a product
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get productDeleteConfirm;

  /// Button to upload product or variant images
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get productUploadImages;

  /// Stock matrix view or header
  ///
  /// In en, this message translates to:
  /// **'Stock Matrix'**
  String get productStockMatrix;

  /// Share action button
  ///
  /// In en, this message translates to:
  /// **'Share to Customer'**
  String get productShareCustomer;

  /// Snackbar message when share text is copied
  ///
  /// In en, this message translates to:
  /// **'Product info copied to clipboard'**
  String get productShareCopied;

  /// Disclaimer appended to shared customer messages
  ///
  /// In en, this message translates to:
  /// **'Prices and stock levels are subject to change. Please confirm before ordering.'**
  String get productStaleDisclaimer;

  /// Customers list screen title
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customerListTitle;

  /// Customer details screen title
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetailTitle;

  /// Button to add a new customer
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get customerAddNew;

  /// Button to edit customer information
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get customerEdit;

  /// Customer name field label
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// Customer phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get customerPhone;

  /// Customer address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get customerAddress;

  /// Customer outstanding debt label
  ///
  /// In en, this message translates to:
  /// **'Current Debt'**
  String get customerDebt;

  /// Customer maximum credit limit label
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get customerCreditLimit;

  /// Repayment cycle period selector
  ///
  /// In en, this message translates to:
  /// **'Repayment Cycle'**
  String get customerRepaymentCycle;

  /// Repayment cycle Weekly
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get customerCycleWeekly;

  /// Repayment cycle Bi-weekly
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get customerCycleBiweekly;

  /// Repayment cycle Monthly
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get customerCycleMonthly;

  /// Button to record customer debt repayment
  ///
  /// In en, this message translates to:
  /// **'Record Repayment'**
  String get customerRecordRepayment;

  /// Snackbar message upon recording repayment
  ///
  /// In en, this message translates to:
  /// **'Repayment recorded successfully'**
  String get customerRepaymentSuccess;

  /// Placeholder for customer search
  ///
  /// In en, this message translates to:
  /// **'Search customers by name or phone...'**
  String get customerSearchPlaceholder;

  /// Empty state when no customers match
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get customerEmpty;

  /// Customer transaction history header
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get customerTransactionHistory;

  /// Available remaining credit label
  ///
  /// In en, this message translates to:
  /// **'Available Credit: {amount}'**
  String customerCreditAvailable(String amount);

  /// Staff list screen title
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get staffListTitle;

  /// Invite staff screen title
  ///
  /// In en, this message translates to:
  /// **'Invite Staff'**
  String get staffInviteTitle;

  /// Staff role selector label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get staffRole;

  /// Staff email field label
  ///
  /// In en, this message translates to:
  /// **'Staff Email'**
  String get staffEmail;

  /// Button to send staff invitation
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get staffSendInvite;

  /// Snackbar message upon sending invite
  ///
  /// In en, this message translates to:
  /// **'Staff invitation sent successfully'**
  String get staffInviteSuccess;

  /// Empty state when no staff members match
  ///
  /// In en, this message translates to:
  /// **'No staff members found'**
  String get staffEmpty;

  /// Active staff status badge
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffActive;

  /// Inactive staff status badge
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get staffInactive;

  /// Confirmation message before deactivating staff
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate this staff member?'**
  String get staffDeactivateConfirm;

  /// Quick sale screen title
  ///
  /// In en, this message translates to:
  /// **'Quick Sale'**
  String get quickSaleTitle;

  /// Quick sale cart panel header
  ///
  /// In en, this message translates to:
  /// **'Current Cart'**
  String get quickSaleCart;

  /// Empty cart placeholder message
  ///
  /// In en, this message translates to:
  /// **'Cart is empty. Tap items to add.'**
  String get quickSaleCartEmpty;

  /// Total summary in quick sale
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String quickSaleTotal(String amount);

  /// Quick sale checkout action button
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get quickSaleCheckout;

  /// Action to empty cart
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get quickSaleClearCart;

  /// Number of items currently selected
  ///
  /// In en, this message translates to:
  /// **'{count} items selected'**
  String quickSaleItemsSelected(int count);

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Metric card for today sales
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get dashboardTodaySales;

  /// Metric card for today orders count
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get dashboardTodayOrders;

  /// Metric card or list for low stock items
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get dashboardLowStockAlert;

  /// Dashboard section for recent orders
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get dashboardRecentOrders;

  /// Metric card for total outstanding credit
  ///
  /// In en, this message translates to:
  /// **'Outstanding Credit'**
  String get dashboardOutstandingCredit;

  /// Browse for customer screen title
  ///
  /// In en, this message translates to:
  /// **'Browse for Customer'**
  String get browseCustomerTitle;

  /// Button to share selected products
  ///
  /// In en, this message translates to:
  /// **'Share Selection ({count})'**
  String browseCustomerShareSelection(int count);

  /// Button to switch to present mode
  ///
  /// In en, this message translates to:
  /// **'Present Mode'**
  String get browseCustomerPresentMode;

  /// Button to exit present mode
  ///
  /// In en, this message translates to:
  /// **'Exit Present Mode'**
  String get browseCustomerExitPresent;

  /// Snackbar message when attempting to share with empty selection
  ///
  /// In en, this message translates to:
  /// **'No items selected to share'**
  String get browseCustomerNoSelection;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings language preference label
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsLanguage;

  /// Settings language preference subtitle
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get settingsLanguageSubtitle;

  /// Shop information section header
  ///
  /// In en, this message translates to:
  /// **'Shop Information'**
  String get settingsShopInfo;

  /// About app section header
  ///
  /// In en, this message translates to:
  /// **'About Shop POS'**
  String get settingsAbout;
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
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
