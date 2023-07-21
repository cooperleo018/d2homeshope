import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/api/api_checker.dart';
import 'package:efood_multivendor_restaurant/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_cancellation_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/running_order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/subscription_model.dart';
import 'package:efood_multivendor_restaurant/data/repository/order_repo.dart';
import 'package:efood_multivendor_restaurant/helper/custom_print.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});
  RxInt count = 0.obs;
  late List<OrderModel> _allOrderList;
  List<OrderModel>? _orderList;
  List<OrderModel>? _runningOrderList;
  List<RunningOrderModel>? _runningOrders;
  List<OrderModel>? _historyOrderList;
  List<OrderDetailsModel>? _orderDetailsModel;
  bool _isLoading = false;
  int _orderIndex = 0;
  bool _campaignOnly = false;
  bool _subscriptionOnly = false;
  String _otp = '';
  int _historyIndex = 0;
  final List<String> _statusList = ['all', 'delivered', 'refunded'];
  bool _paginate = false;
  int? _pageSize;
  List<int> _offsetList = [];
  int _offset = 1;
  String _orderType = 'all';
  OrderModel? _orderModel;
  List<CancellationData>? _orderCancelReasons;
  String? _cancelReason = '';
  SubscriptionModel? _subscriptionModel;
  bool _isFirstTimeSubOrder = true;

  List<OrderModel>? get orderList => _orderList;
  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<RunningOrderModel>? get runningOrders => _runningOrders;
  List<OrderModel>? get historyOrderList => _historyOrderList;
  List<OrderDetailsModel>? get orderDetailsModel => _orderDetailsModel;
  bool get isLoading => _isLoading;
  int get orderIndex => _orderIndex;
  bool get campaignOnly => _campaignOnly;
  bool get subscriptionOnly => _subscriptionOnly;
  String get otp => _otp;
  int get historyIndex => _historyIndex;
  List<String> get statusList => _statusList;
  bool get paginate => _paginate;
  int? get pageSize => _pageSize;
  int get offset => _offset;
  String get orderType => _orderType;
  OrderModel? get orderModel => _orderModel;
  List<CancellationData>? get orderCancelReasons => _orderCancelReasons;
  String? get cancelReason => _cancelReason;
  SubscriptionModel? get subscriptionModel => _subscriptionModel;

  void setOrderCancelReason(String? reason) {
    _cancelReason = reason;
    update();
  }

  Future<void> getOrderCancelReasons() async {
    Response response = await orderRepo.getCancelReasons();
    if (response.statusCode == 200) {
      OrderCancellationBody orderCancellationBody =
          OrderCancellationBody.fromJson(response.body);
      _orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        _orderCancelReasons!.add(element);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> setOrderDetails(OrderModel orderModel) async {
    if (orderModel.orderStatus != null &&
        orderModel.customer != null &&
        orderModel.deliveryMan != null) {
      _orderModel = orderModel;
      customPrint('having all order model');
    } else {
      customPrint('having not all order model');
      Response response = await orderRepo.getOrderWithId(orderModel.id);
      if (response.statusCode == 200) {
        _orderModel = OrderModel.fromJson(response.body);
        customPrint('order model : ${_orderModel!.toJson()}');
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getAllOrders() async {
    _historyIndex = 0;
    Response response = await orderRepo.getAllOrders();
    if (response.statusCode == 200) {
      _allOrderList = [];
      _orderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        _allOrderList.add(orderModel);
        _orderList!.add(orderModel);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
   upadateCount(){
 count.value++;
   }
  Future<void> getCurrentOrders() async {
    Response response = await orderRepo.getCurrentOrders();
    if (response.statusCode == 200) {
      _runningOrderList = [];
      _runningOrders = [
        RunningOrderModel(status: 'pending', orderList: []),
        RunningOrderModel(status: 'confirmed', orderList: []),
        RunningOrderModel(status: 'cooking', orderList: []),
        RunningOrderModel(status: 'ready_for_handover', orderList: []),
        RunningOrderModel(status: 'food_on_the_way', orderList: []),
      ];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        // print('--------subscriptionId->>> : ${_orderModel.subscriptionId}/----${_orderModel.id}');
        _runningOrderList!.add(orderModel);
      });
      _campaignOnly = true;
      toggleCampaignOnly();
      // _subscriptionOnly = true;
      // toggleSubscriptionOnly();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
   
  }

  // Future<void> getCompletedOrders() async {
  //   Response response = await orderRepo.getCompletedOrders();
  //   if(response.statusCode == 200) {
  //     _historyOrderList = [];
  //     response.body.forEach((order) {
  //       OrderModel _orderModel = OrderModel.fromJson(order);
  //       _historyOrderList.add(_orderModel);
  //     });
  //   }else {
  //     ApiChecker.checkApi(response);
  //   }
  //   setHistoryIndex(0);
  // }

  Future<void> getPaginatedOrders(int offset, bool reload) async {
    if (offset == 1 || reload) {
      _offsetList = [];
      _offset = 1;
      if (reload) {
        _historyOrderList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await orderRepo.getPaginatedOrderList(
          offset, _statusList[_historyIndex]);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        if (response.body != null) {
          _historyOrderList!
              .addAll(PaginatedOrderModel.fromJson(response.body).orders!);
        }
        _pageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void setOrderType(String type) {
    _orderType = type;
    getPaginatedOrders(1, true);
  }

  Future<bool> updateOrderStatus(int? orderID, String status,
      {bool back = false, String? processingTime, String? reason}) async {
    _isLoading = true;
    update();
    UpdateStatusBody updateStatusBody = UpdateStatusBody(
      orderId: orderID,
      status: status,
      otp: status == 'delivered' ? _otp : null,
      processingTime: processingTime,
      reason: reason,
    );
    Response response = await orderRepo.updateOrderStatus(updateStatusBody);
    Get.back();
    bool isSuccess;
    if (response.statusCode == 200) {
      if (back) {
        Get.back();
      }
      getCurrentOrders();
      showCustomSnackBar(response.body['message'], isError: false);
      isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    _isLoading = false;
    update();
    return isSuccess;
  }

  Future<void> getOrderDetails(int? orderID) async {
    _orderDetailsModel = null;
    Response response = await orderRepo.getOrderDetails(orderID);
    if (response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body['order']['details'].forEach((orderDetails) =>
          _orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
      if (response.body['order']['subscription'] != null) {
        _subscriptionModel =
            SubscriptionModel.fromJson(response.body['order']['subscription']);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderIndex(int index) {
    _orderIndex = index;
    update();
  }

  void toggleCampaignOnly() {
    if (_subscriptionOnly) {
      _subscriptionOnly = !_subscriptionOnly;
    }
    _campaignOnly = !_campaignOnly;
    _runningOrders![0].orderList = [];
    _runningOrders![1].orderList = [];
    _runningOrders![2].orderList = [];
    _runningOrders![3].orderList = [];
    _runningOrders![4].orderList = [];
    for (var order in _runningOrderList!) {
      if (order.orderStatus == 'pending' &&
          (Get.find<SplashController>().configModel!.orderConfirmationModel !=
                  'deliveryman' ||
              order.orderType == 'take_away' ||
              Get.find<AuthController>()
                      .profileModel!
                      .restaurants![0]
                      .selfDeliverySystem ==
                  1) &&
          (_campaignOnly
              ? order.foodCampaign == 1
              : order.subscriptionId != null
                  ? false
                  : order.foodCampaign == 0)) {
        _runningOrders![0].orderList.add(order);
      } else if ((order.orderStatus == 'confirmed' ||
              (order.orderStatus == 'accepted' && order.confirmed != null)) &&
          (_campaignOnly
              ? order.foodCampaign == 1
              : order.subscriptionId != null
                  ? false
                  : order.foodCampaign == 0)) {
        _runningOrders![1].orderList.add(order);
      } else if (order.orderStatus == 'processing' &&
          (_campaignOnly
              ? order.foodCampaign == 1
              : order.subscriptionId != null
                  ? false
                  : order.foodCampaign == 0)) {
        _runningOrders![2].orderList.add(order);
      } else if (order.orderStatus == 'handover' &&
          (_campaignOnly
              ? order.foodCampaign == 1
              : order.subscriptionId != null
                  ? false
                  : order.foodCampaign == 0)) {
        _runningOrders![3].orderList.add(order);
      } else if (order.orderStatus == 'picked_up' &&
          (_campaignOnly
              ? order.foodCampaign == 1
              : order.subscriptionId != null
                  ? false
                  : order.foodCampaign == 0)) {
        _runningOrders![4].orderList.add(order);
      }
    }
    update();
  }

  void toggleSubscriptionOnly() {
    if (_campaignOnly && !_isFirstTimeSubOrder) {
      _campaignOnly = !_campaignOnly;
    }
    _isFirstTimeSubOrder = false;
    _subscriptionOnly = !_subscriptionOnly;
    _runningOrders![0].orderList = [];
    _runningOrders![1].orderList = [];
    _runningOrders![2].orderList = [];
    _runningOrders![3].orderList = [];
    _runningOrders![4].orderList = [];
    for (var order in _runningOrderList!) {
      if (order.orderStatus == 'pending' &&
          (Get.find<SplashController>().configModel!.orderConfirmationModel !=
                  'deliveryman' ||
              order.orderType == 'take_away' ||
              Get.find<AuthController>()
                      .profileModel!
                      .restaurants![0]
                      .selfDeliverySystem ==
                  1) &&
          (_subscriptionOnly
              ? order.subscriptionId != null
              : order.subscriptionId == null)) {
        _runningOrders![0].orderList.add(order);
      } else if ((order.orderStatus == 'confirmed' ||
              (order.orderStatus == 'accepted' && order.confirmed != null)) &&
          (_subscriptionOnly
              ? order.subscriptionId != null
              : order.subscriptionId == null)) {
        _runningOrders![1].orderList.add(order);
      } else if (order.orderStatus == 'processing' &&
          (_subscriptionOnly
              ? order.subscriptionId != null
              : order.subscriptionId == null)) {
        _runningOrders![2].orderList.add(order);
      } else if (order.orderStatus == 'handover' &&
          (_subscriptionOnly
              ? order.subscriptionId != null
              : order.subscriptionId == null)) {
        _runningOrders![3].orderList.add(order);
      } else if (order.orderStatus == 'picked_up' &&
          (_subscriptionOnly
              ? order.subscriptionId != null
              : order.subscriptionId == null)) {
        _runningOrders![4].orderList.add(order);
      }
    }
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if (otp != '') {
      update();
    }
  }

  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedOrders(offset, true);
    update();
  }

  // int countHistoryList(int index) {
  //   int _length;
  //   if(index == 0) {
  //     _length = _historyOrderList.length;
  //   }else {
  //     _length = _historyOrderList.where((order) => order.orderStatus == _statusList[index]).length;
  //   }
  //   return _length;
  // }
}
