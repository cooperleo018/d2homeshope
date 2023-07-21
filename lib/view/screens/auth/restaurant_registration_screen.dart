import 'dart:io';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/body/restaurant_body.dart';
import 'package:efood_multivendor_restaurant/helper/custom_print.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:efood_multivendor_restaurant/view/screens/auth/business_plan/widgets/registration_stepper_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/auth/widget/select_location_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantRegistrationScreen extends StatefulWidget {
  const RestaurantRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantRegistrationScreen> createState() => _RestaurantRegistrationScreenState();
}

class _RestaurantRegistrationScreenState extends State<RestaurantRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _minTimeController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _minTimeFocus = FocusNode();
  final FocusNode _maxTimeFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final bool _canBack = false;

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getCuisineList();
    Get.find<AuthController>().getZoneList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      List<int> cuisines0 = [];
      if(authController.cuisineModel != null) {
        for(int index=0; index<authController.cuisineModel!.cuisines!.length; index++) {
          if(authController.cuisineModel!.cuisines![index].status == 1 && !authController.selectedCuisines!.contains(index)) {
            cuisines0.add(index);
          }
        }
      }
        return WillPopScope(
          onWillPop: () async{
            if(_canBack) {
              return true;
            }else {
              authController.showBackPressedDialogue('your_registration_not_setup_yet'.tr);
              return false;
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(title: 'restaurant_application'.tr, onBackPressed: () =>  authController.showBackPressedDialogue('your_registration_not_setup_yet'.tr)),
            body: Center(child: SizedBox(width: context.width, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              const SizedBox(height: Dimensions.paddingSizeDefault),
              const RegistrationStepperWidget(status: '0'),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    CustomTextField(
                      hintText: 'restaurant_name'.tr,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      nextFocus: _addressFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      showTitle: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextField(
                      hintText: 'restaurant_address'.tr,
                      controller: _addressController,
                      focusNode: _addressFocus,
                      nextFocus: _vatFocus,
                      inputType: TextInputType.text,
                      capitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      showTitle: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextField(
                      hintText: 'vat_tax'.tr,
                      controller: _vatController,
                      focusNode: _vatFocus,
                      nextFocus: _minTimeFocus,
                      inputType: TextInputType.number,
                      isAmount: true,
                      showTitle: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'cuisines'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Autocomplete<int>(
                        optionsBuilder: (TextEditingValue value) {
                          if(value.text.isEmpty) {
                            return const Iterable<int>.empty();
                          }else {
                            return cuisines0.where((cuisine) => authController.cuisineModel!.cuisines![cuisine].name!.toLowerCase().contains(value.text.toLowerCase()));
                          }
                        },
                        fieldViewBuilder: (context, controller, node, onComplete) {
                          _c = controller;
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                            ),
                            child: TextField(
                              controller: controller,
                              focusNode: node,
                              onEditingComplete: () {
                                onComplete();
                                controller.text = '';
                              },
                              decoration: InputDecoration(
                                hintText: 'cuisines'.tr,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), borderSide: BorderSide.none),
                              ),
                            ),
                          );
                        },
                        displayStringForOption: (value) => authController.cuisineModel!.cuisines![value].name!,
                        onSelected: (int value) {
                          _c.text = '';
                          authController.setSelectedCuisineIndex(value, true);
                        },
                      ),

                      SizedBox(height: authController.selectedCuisines!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),
                      SizedBox(
                        height: authController.selectedCuisines!.isNotEmpty ? 40 : 0,
                        child: ListView.builder(
                          itemCount: authController.selectedCuisines!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Row(children: [
                                Text(
                                  authController.cuisineModel!.cuisines![authController.selectedCuisines![index]].name!,
                                  style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                                ),
                                InkWell(
                                  onTap: () => authController.removeCuisine(index),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: Icon(Icons.close, size: 15, color: Theme.of(context).cardColor),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Row(children: [
                      Expanded(child: CustomTextField(
                        hintText: 'minimum_delivery_time'.tr,
                        controller: _minTimeController,
                        focusNode: _minTimeFocus,
                        nextFocus: _maxTimeFocus,
                        inputType: TextInputType.number,
                        isNumber: true,
                        showTitle: true,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: CustomTextField(
                        hintText: 'maximum_delivery_time'.tr,
                        controller: _maxTimeController,
                        focusNode: _maxTimeFocus,
                        inputType: TextInputType.number,
                        isNumber: true,
                        inputAction: TextInputAction.done,
                        showTitle: true,
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'logo'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                          authController.pickedLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                        ) : Image.file(
                          File(authController.pickedLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                        ) : Image.asset(
                          Images.placeholder, width: 150, height: 120, fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => authController.pickImageForReg(true, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'cover_photo'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                          authController.pickedCover!.path, width: context.width, height: 170, fit: BoxFit.cover,
                        ) : Image.file(
                          File(authController.pickedCover!.path), width: context.width, height: 170, fit: BoxFit.cover,
                        ) : Image.asset(
                          Images.placeholder, width: context.width, height: 170, fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => authController.pickImageForReg(false, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 3, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 50),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    authController.zoneList != null ? const SelectLocationView(fromView: true) : const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Center(child: Text(
                      'owner_information'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(children: [
                      Expanded(child: CustomTextField(
                        hintText: 'first_name'.tr,
                        controller: _fNameController,
                        focusNode: _fNameFocus,
                        nextFocus: _lNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: true,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: CustomTextField(
                        hintText: 'last_name'.tr,
                        controller: _lNameController,
                        focusNode: _lNameFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: true,
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextField(
                      hintText: 'phone'.tr,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.phone,
                      showTitle: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Center(child: Text(
                      'login_information'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextField(
                      hintText: 'email'.tr,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _passwordFocus,
                      inputType: TextInputType.emailAddress,
                      showTitle: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(children: [
                      Expanded(child: CustomTextField(
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        showTitle: true,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: CustomTextField(
                        hintText: 'confirm_password'.tr,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        showTitle: true,
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    !authController.isLoading ? CustomButton(
                      buttonText: 'submit'.tr,
                      onPressed: () {
                        String name = _nameController.text.trim();
                        String address = _addressController.text.trim();
                        String vat = _vatController.text.trim();
                        String minTime = _minTimeController.text.trim();
                        String maxTime = _maxTimeController.text.trim();
                        String fName = _fNameController.text.trim();
                        String lName = _lNameController.text.trim();
                        String phone = _phoneController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String confirmPassword = _confirmPasswordController.text.trim();
                        if(name.isEmpty) {
                          showCustomSnackBar('enter_restaurant_name'.tr);
                        }else if(address.isEmpty) {
                          showCustomSnackBar('enter_restaurant_address'.tr);
                        }else if(vat.isEmpty) {
                          showCustomSnackBar('enter_vat_amount'.tr);
                        }else if(minTime.isEmpty) {
                          showCustomSnackBar('enter_minimum_delivery_time'.tr);
                        }else if(maxTime.isEmpty) {
                          showCustomSnackBar('enter_maximum_delivery_time'.tr);
                        }else if(double.parse(minTime) > double.parse(maxTime)) {
                          showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                        }else if(authController.pickedLogo == null) {
                          showCustomSnackBar('select_restaurant_logo'.tr);
                        }else if(authController.pickedCover == null) {
                          showCustomSnackBar('select_restaurant_cover_photo'.tr);
                        }else if(authController.restaurantLocation == null) {
                          showCustomSnackBar('set_restaurant_location'.tr);
                        } else if(fName.isEmpty) {
                          showCustomSnackBar('enter_your_first_name'.tr);
                        }else if(lName.isEmpty) {
                          showCustomSnackBar('enter_your_last_name'.tr);
                        }else if(phone.isEmpty) {
                          showCustomSnackBar('enter_your_phone_number'.tr);
                        }else if(email.isEmpty) {
                          showCustomSnackBar('enter_your_email_address'.tr);
                        }else if(!GetUtils.isEmail(email)) {
                          showCustomSnackBar('enter_a_valid_email_address'.tr);
                        }else if(password.isEmpty) {
                          showCustomSnackBar('enter_password'.tr);
                        }else if(password.length < 6) {
                          showCustomSnackBar('password_should_be'.tr);
                        }else if(password != confirmPassword) {
                          showCustomSnackBar('confirm_password_does_not_matched'.tr);
                        }else {

                          List<String> cuisines = [];
                          for (var index in authController.selectedCuisines!) {
                            cuisines.add(authController.cuisineModel!.cuisines![index].id.toString());
                          }
                          customPrint('-----cuisines------: $cuisines');

                          authController.registerRestaurant(RestaurantBody(
                            restaurantName: name, restaurantAddress: address, vat: vat, minDeliveryTime: minTime,
                            maxDeliveryTime: maxTime, lat: authController.restaurantLocation!.latitude.toString(), email: email,
                            lng: authController.restaurantLocation!.longitude.toString(), fName: fName, lName: lName, phone: phone,
                            password: password, zoneId: authController.zoneList![authController.selectedZoneIndex!].id.toString(),
                            cuisineId: cuisines,
                          ));
                        }
                      },
                    ) : const Center(child: CircularProgressIndicator()),

                  ]),
                ),
              ),

            ])
            )),
          ),
        );
      }
    );
  }

}
