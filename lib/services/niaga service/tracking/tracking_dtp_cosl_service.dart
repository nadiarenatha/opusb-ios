import '../../../model/niaga/tracking/ptp-cosd/dtp-cosl/tracking_dtp_cosl.dart';

abstract class TrackingNiagaDTPCOSLService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<TrackingDtpCoslAccesses>> getTrackingDTPCOSL(
      // {String? email, int? page, int? size}
      String noPL
      );
}
