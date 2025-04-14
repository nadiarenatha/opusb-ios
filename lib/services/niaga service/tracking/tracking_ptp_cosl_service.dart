import '../../../model/niaga/tracking/ptp-cosd/ptp-cosl/tracking_ptp_cosl.dart';

abstract class TrackingNiagaPTPCOSLService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<TrackingPtpCoslAccesses>> getTrackingPTPCOSL(
      // {String? email, int? page, int? size}
      String noPL
      );
}
