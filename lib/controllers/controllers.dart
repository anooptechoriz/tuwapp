import 'package:flutter/cupertino.dart';

class EditProfileControllers {
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController dateController = TextEditingController();
  static TextEditingController countryController = TextEditingController();
  static TextEditingController regionController = TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController aboutController = TextEditingController();
  static TextEditingController genderController = TextEditingController();
}

class PhoneNumberControllers {
  static TextEditingController phoneNumCon = TextEditingController();
  static TextEditingController otpCon = TextEditingController();
}

class ProfileServiceControllers {
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController civilCardController = TextEditingController();
  static TextEditingController dateController = TextEditingController();
  static TextEditingController regionController = TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
}

class ChooseServiceControllers {
  static TextEditingController serviceGroupController = TextEditingController();
  static TextEditingController serviceListController = TextEditingController();
  static TextEditingController registrationController = TextEditingController();
}

class PaymentServiceControllers {
  static TextEditingController cardHolderController = TextEditingController();
  static TextEditingController cardNumberController = TextEditingController();
  static TextEditingController dateController = TextEditingController();
  static TextEditingController cvvCodeController = TextEditingController();
  static TextEditingController couponController = TextEditingController();
}

class ServiceControllers {
  static TextEditingController servicerController = TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController regionController = TextEditingController();
  static TextEditingController mapController = TextEditingController();
  static TextEditingController servicenameController = TextEditingController();
  //  static TextEditingController stateController = TextEditingController();
}

class AddressEditControllers {
  static TextEditingController addressNameController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
  static TextEditingController countryController = TextEditingController();
  static TextEditingController regionController = TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController flatNoController = TextEditingController();
  static TextEditingController searchController = TextEditingController();
}

class GoogleMapControllers {
  static TextEditingController googleMapSearchController =
      TextEditingController();
}

class ServiceManProfileEdit {
  static TextEditingController stateController = TextEditingController();
  static TextEditingController regionController = TextEditingController();
  static TextEditingController searchController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController detailsController = TextEditingController();
}

class ReportCustomerControllers {
  static TextEditingController reasonController = TextEditingController();
  static TextEditingController commentController = TextEditingController();
}

class ServiceNameControllers {
  static TextEditingController service = TextEditingController();
}

clearReportControllers() {
  ReportCustomerControllers.reasonController.clear();
  ReportCustomerControllers.commentController.clear();
}

TextEditingController msgController = TextEditingController();

clearAddressController() {
  AddressEditControllers.addressNameController.clear();
  AddressEditControllers.addressController.clear();
  AddressEditControllers.countryController.clear();
  AddressEditControllers.regionController.clear();
  AddressEditControllers.stateController.clear();
  AddressEditControllers.flatNoController.clear();
}
