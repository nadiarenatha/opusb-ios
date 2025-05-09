import '../../../model/niaga/order.dart';

abstract class CreateOrderFCLService {
  Future<OrderAccesses> createOrderFCL(
      String email,
      String createdBy,
      int userId,
      String createdDate,
      String businessUnit,
      String portAsal,
      String portTujuan,
      String originalCity,
      String originalAddress,
      String originalPicName,
      String originalPicNumber,
      String cargoReadyDate,
      String destinationCity,
      String destinationAddress,
      String destinationPicName,
      String destinationPicNumber,
      String contractNo,
      String komoditi,
      String productDescription,
      String containerSize,
      int quantity,
      int amount,
      String loctidUocAsal,
      String loctidUocTujuan,
      String loctidPortAsal,
      String loctidPortTujuan,
      bool point,
      int price,
      double userTotalWeight,
      bool flagPaymentWa,
      bool paymentStatus,
      int pointUse,
      int amountCargo,
      String etd);
}
