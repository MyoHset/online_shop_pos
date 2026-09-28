// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try Again';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonAll => 'All';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonOk => 'OK';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonDate => 'Date';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonDiscount => 'Discount';

  @override
  String get commonTax => 'Tax';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonNone => 'None';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSignOut => 'Sign Out';

  @override
  String get commonSignOutConfirm => 'Are you sure you want to sign out?';

  @override
  String commonVersion(String version) {
    return 'v$version';
  }

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonLanguageEn => 'English';

  @override
  String get commonLanguageMy => 'မြန်မာ (Unicode)';

  @override
  String get commonNoResults => 'No results found';

  @override
  String get commonNoData => 'No data available';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonSelect => 'Select';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navQuickSale => 'Quick Sale';

  @override
  String get navQuickSaleShort => 'Sale';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProducts => 'Products';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navStaff => 'Staff';

  @override
  String get navSettings => 'Settings';

  @override
  String get navBrowseForCustomer => 'Browse for Customer';

  @override
  String get navPresentMode => 'Present Mode';

  @override
  String get navManagement => 'Management';

  @override
  String get navMainNavigation => 'Main Navigation';

  @override
  String get authLogin => 'Sign In';

  @override
  String get authRegisterShop => 'Register Shop';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authShopName => 'Shop Name';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authPhone => 'Phone Number';

  @override
  String get authLoginSubtitle => 'Welcome back! Please sign in to your POS.';

  @override
  String get authRegisterSubtitle => 'Create a new shop and admin account.';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email to receive a password reset link.';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authBackToLogin => 'Back to Sign In';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get authDontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get authCheckEmailForReset =>
      'A password reset link has been sent to your email.';

  @override
  String get authLoginSuccess => 'Welcome back!';

  @override
  String get authRegisterSuccess => 'Shop registered successfully!';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleStaff => 'Staff';

  @override
  String get errorSomethingWentWrong => 'Something went wrong';

  @override
  String get errorInvalidCredentials => 'Email or password is incorrect.';

  @override
  String get errorEmailNotConfirmed =>
      'Please confirm your email before signing in.';

  @override
  String get errorUserAlreadyRegistered =>
      'An account with this email already exists.';

  @override
  String get errorPasswordTooShort =>
      'Password must be at least 8 characters long.';

  @override
  String get errorInsufficientStock =>
      'Insufficient stock available for this operation.';

  @override
  String get errorPermissionDenied =>
      'You do not have permission to perform this action.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorNotFound => 'The requested item was not found.';

  @override
  String get errorValidation => 'Please check your input and try again.';

  @override
  String get errorDiscountExceedsLimit =>
      'Discount exceeds your allowed limit — ask a manager.';

  @override
  String get errorServer => 'Server error occurred. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get errorImageUpload => 'Failed to upload image. Please try again.';

  @override
  String get errorCache => 'Failed to access local cache.';

  @override
  String get errorFailedToLoadData => 'Failed to load data.';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationInvalidEmail => 'Please enter a valid email';

  @override
  String get validationPasswordLength =>
      'Password must be at least 6 characters';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationInvalidPhone => 'Please enter a valid phone number';

  @override
  String get validationInvalidNumber => 'Please enter a valid number';

  @override
  String get validationPositiveNumber => 'Value must be greater than 0';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusPacked => 'Packed';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderTypeInStore => 'In-Store';

  @override
  String get orderTypeOnline => 'Online';

  @override
  String get orderTypeCredit => 'Credit';

  @override
  String get orderListTitle => 'Orders';

  @override
  String get orderDetailTitle => 'Order Details';

  @override
  String get orderCreateNew => 'New Order';

  @override
  String orderId(String id) {
    return 'Order #$id';
  }

  @override
  String orderItems(int count) {
    return 'Items ($count)';
  }

  @override
  String orderItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get orderCustomer => 'Customer';

  @override
  String get orderDate => 'Order Date';

  @override
  String get orderTotal => 'Total Amount';

  @override
  String get orderPaymentStatus => 'Payment Status';

  @override
  String get orderUpdateStatus => 'Update Status';

  @override
  String get orderCancelConfirm =>
      'Are you sure you want to cancel this order?';

  @override
  String get orderCancelledSuccess => 'Order cancelled successfully';

  @override
  String get orderStatusUpdatedSuccess => 'Order status updated';

  @override
  String get orderFilterAll => 'All Orders';

  @override
  String get orderFilterToday => 'Today';

  @override
  String get orderFilterYesterday => 'Yesterday';

  @override
  String get orderFilterThisWeek => 'This Week';

  @override
  String get orderFilterThisMonth => 'This Month';

  @override
  String get orderFilterCustomDate => 'Custom Date';

  @override
  String get orderSearchPlaceholder => 'Search by order # or customer...';

  @override
  String get orderEmpty => 'No orders found';

  @override
  String get orderApplyDiscount => 'Apply Discount';

  @override
  String get orderDiscountType => 'Discount Type';

  @override
  String get orderDiscountAmount => 'Discount Amount';

  @override
  String get orderDiscountPercentage => 'Percentage (%)';

  @override
  String get orderDiscountFixed => 'Fixed Amount (Ks)';

  @override
  String get orderDiscountApplied => 'Discount applied successfully';

  @override
  String get orderInstantSaleSuccess => 'Sale completed successfully!';

  @override
  String get orderPrintReceipt => 'Print Receipt';

  @override
  String get discountTypeNone => 'No Discount';

  @override
  String get discountTypePercentage => 'Percentage (%)';

  @override
  String get discountTypeFixed => 'Fixed Amount';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodKbzpay => 'KBZPay';

  @override
  String get paymentMethodWavepay => 'WavePay';

  @override
  String get paymentMethodApay => 'AYA Pay';

  @override
  String get paymentMethodCbpay => 'CB Pay';

  @override
  String get paymentMethodBankTransfer => 'Bank Transfer';

  @override
  String get paymentMethodCod => 'Cash on Delivery (COD)';

  @override
  String get paymentMethodCredit => 'Credit';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusUnpaid => 'Unpaid';

  @override
  String get paymentStatusPartial => 'Partially Paid';

  @override
  String get paymentStatusRefunded => 'Refunded';

  @override
  String get paymentEntryTitle => 'Payment Entry';

  @override
  String get paymentSelectMethod => 'Select Payment Method';

  @override
  String get paymentAmount => 'Payment Amount';

  @override
  String get paymentReceived => 'Amount Received';

  @override
  String get paymentChange => 'Change Due';

  @override
  String get paymentReference => 'Transaction / Slip ID';

  @override
  String get paymentComplete => 'Complete Payment';

  @override
  String get paymentSuccess => 'Payment recorded successfully';

  @override
  String get productAddNew => 'Add Product';

  @override
  String get productEdit => 'Edit Product';

  @override
  String get productListTitle => 'Products';

  @override
  String get productDetailTitle => 'Product Details';

  @override
  String get productName => 'Product Name';

  @override
  String get productCategory => 'Category';

  @override
  String get productBrand => 'Brand';

  @override
  String get productDescription => 'Description';

  @override
  String get productPrice => 'Price';

  @override
  String get productCostPrice => 'Cost Price';

  @override
  String get productStock => 'Stock';

  @override
  String get productSku => 'SKU / Barcode';

  @override
  String get productInStock => 'In Stock';

  @override
  String get productOutOfStock => 'Out of Stock';

  @override
  String get productLowStock => 'Low Stock';

  @override
  String productStockLeft(int count) {
    return '$count left';
  }

  @override
  String get productVariants => 'Variants';

  @override
  String get productAddVariant => 'Add Variant';

  @override
  String get productEditVariant => 'Edit Variant';

  @override
  String get productSearchPlaceholder => 'Search products by name, SKU...';

  @override
  String get productEmpty => 'No products found';

  @override
  String get productCreatedSuccess => 'Product created successfully';

  @override
  String get productUpdatedSuccess => 'Product updated successfully';

  @override
  String get productDeletedSuccess => 'Product deleted successfully';

  @override
  String get productDeleteConfirm =>
      'Are you sure you want to delete this product?';

  @override
  String get productUploadImages => 'Upload Images';

  @override
  String get productStockMatrix => 'Stock Matrix';

  @override
  String get productShareCustomer => 'Share to Customer';

  @override
  String get productShareCopied => 'Product info copied to clipboard';

  @override
  String get productStaleDisclaimer =>
      'Prices and stock levels are subject to change. Please confirm before ordering.';

  @override
  String get customerListTitle => 'Customers';

  @override
  String get customerDetailTitle => 'Customer Details';

  @override
  String get customerAddNew => 'Add Customer';

  @override
  String get customerEdit => 'Edit Customer';

  @override
  String get customerName => 'Customer Name';

  @override
  String get customerPhone => 'Phone Number';

  @override
  String get customerAddress => 'Address';

  @override
  String get customerDebt => 'Current Debt';

  @override
  String get customerCreditLimit => 'Credit Limit';

  @override
  String get customerRepaymentCycle => 'Repayment Cycle';

  @override
  String get customerCycleWeekly => 'Weekly';

  @override
  String get customerCycleBiweekly => 'Bi-weekly';

  @override
  String get customerCycleMonthly => 'Monthly';

  @override
  String get customerRecordRepayment => 'Record Repayment';

  @override
  String get customerRepaymentSuccess => 'Repayment recorded successfully';

  @override
  String get customerSearchPlaceholder =>
      'Search customers by name or phone...';

  @override
  String get customerEmpty => 'No customers found';

  @override
  String get customerTransactionHistory => 'Transaction History';

  @override
  String customerCreditAvailable(String amount) {
    return 'Available Credit: $amount';
  }

  @override
  String get staffListTitle => 'Staff Members';

  @override
  String get staffInviteTitle => 'Invite Staff';

  @override
  String get staffRole => 'Role';

  @override
  String get staffEmail => 'Staff Email';

  @override
  String get staffSendInvite => 'Send Invite';

  @override
  String get staffInviteSuccess => 'Staff invitation sent successfully';

  @override
  String get staffEmpty => 'No staff members found';

  @override
  String get staffActive => 'Active';

  @override
  String get staffInactive => 'Inactive';

  @override
  String get staffDeactivateConfirm =>
      'Are you sure you want to deactivate this staff member?';

  @override
  String get quickSaleTitle => 'Quick Sale';

  @override
  String get quickSaleCart => 'Current Cart';

  @override
  String get quickSaleCartEmpty => 'Cart is empty. Tap items to add.';

  @override
  String quickSaleTotal(String amount) {
    return 'Total: $amount';
  }

  @override
  String get quickSaleCheckout => 'Checkout';

  @override
  String get quickSaleClearCart => 'Clear Cart';

  @override
  String quickSaleItemsSelected(int count) {
    return '$count items selected';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardTodaySales => 'Today\'s Sales';

  @override
  String get dashboardTodayOrders => 'Today\'s Orders';

  @override
  String get dashboardLowStockAlert => 'Low Stock Items';

  @override
  String get dashboardRecentOrders => 'Recent Orders';

  @override
  String get dashboardOutstandingCredit => 'Outstanding Credit';

  @override
  String get browseCustomerTitle => 'Browse for Customer';

  @override
  String browseCustomerShareSelection(int count) {
    return 'Share Selection ($count)';
  }

  @override
  String get browseCustomerPresentMode => 'Present Mode';

  @override
  String get browseCustomerExitPresent => 'Exit Present Mode';

  @override
  String get browseCustomerNoSelection => 'No items selected to share';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'App Language';

  @override
  String get settingsLanguageSubtitle => 'Select your preferred language';

  @override
  String get settingsShopInfo => 'Shop Information';

  @override
  String get settingsAbout => 'About Shop POS';
}
