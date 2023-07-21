import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputDialog extends StatefulWidget {
  final String icon;
  final String? title;
  final String description;
  final Function(String? value) onPressed;
  const InputDialog(
      {Key? key,
      required this.icon,
      this.title,
      required this.description,
      required this.onPressed})
      : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
//  final TextEditingController _textEditingController = TextEditingController();

  int selectedIndex = 0;
  String? time = "${((0 + 1) * 10) + 5} mins";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Image.asset(widget.icon, width: 50, height: 50),
                ),
                widget.title != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          widget.title!,
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge,
                              color: Colors.red),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Text(widget.description,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Wrap(
                  children: List.generate(
                      6,
                      (index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                time = "${((index + 1) * 10) + 5}";
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: index == selectedIndex
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 7),
                                  child: Text("${((index + 1) * 10) + 5} mins",
                                      style: robotoMedium.copyWith(
                                          color: index == selectedIndex
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .primaryColor)),
                                ),
                              ),
                            ),
                          )),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       border:
                //           Border.all(color: Theme.of(context).disabledColor),
                //       borderRadius:
                //           BorderRadius.circular(Dimensions.radiusSmall)),
                //   child: CustomTextField(
                //     maxLines: 1,
                //     controller: _textEditingController,
                //     hintText: 'enter_processing_time'.tr,
                //     isEnabled: true,
                //     inputType: TextInputType.number,
                //     inputAction: TextInputAction.done,
                //   ),
                // ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                GetBuilder<OrderController>(builder: (orderController) {
                  return (orderController.isLoading)
                      ? const Center(child: CircularProgressIndicator())
                      : Row(children: [
                          Expanded(
                              child: CustomButton(
                            buttonText: 'submit'.tr,
                            onPressed: () {
                              if (time == null) {
                                showCustomSnackBar(
                                    'please_provide_processing_time'.tr);
                              } else {
                                widget.onPressed(
                                    "${((selectedIndex + 1) * 10) + 5}");
                              }
                            },
                            height: 40,
                          )),
                          const SizedBox(width: Dimensions.paddingSizeLarge),
                          Expanded(
                              child: TextButton(
                            onPressed: () => widget.onPressed(null),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.3),
                              minimumSize: const Size(1170, 40),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall)),
                            ),
                            child: Text(
                              'cancel'.tr,
                              textAlign: TextAlign.center,
                              style: robotoBold.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                          )),
                        ]);
                }),
              ]),
            ),
          )),
    );
  }
}
