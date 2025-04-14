import '../../../model/niaga/tracking/ptp-cosd/ptd-cosd/tracking_ptd_cosd.dart';

abstract class TrackingNiagaPTDCOSDService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<TrackingPtdCosdAccesses>> getTrackingPTDCOSD(
      // {String? email, int? page, int? size}
      String noPL
      );
}
