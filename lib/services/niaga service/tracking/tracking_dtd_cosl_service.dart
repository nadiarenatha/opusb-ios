import '../../../model/niaga/tracking/ptp-cosd/dtd-cosl/tracking_dtd_cosl.dart';

abstract class TrackingNiagaDTDCOSLService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<TrackingDtdCoslAccesses>> getTrackingDTDCOSL(
      // {String? email, int? page, int? size}
      String noPL
      );
}
