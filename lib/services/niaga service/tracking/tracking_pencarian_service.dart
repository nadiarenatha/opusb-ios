import '../../../model/niaga/tracking/ptp-cosd/header-tracking/header_tracking.dart';

abstract class TrackingPencarianService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<HeaderTrackingAccesses> getTrackingPencarian(String noPL);
}
