import '../../../model/niaga/tracking/ptp-cosd/ptd-cosl/tracking_ptd_cosl.dart';

abstract class TrackingNiagaPTDCOSLService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<TrackingPtdCoslAccesses>> getTrackingPTDCOSL(
      // {String? email, int? page, int? size}
      String noPL
      );
}
