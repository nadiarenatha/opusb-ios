import '../../../model/niaga/tracking/ptp-cosd/tracking_ptp_cosd.dart';

abstract class TrackingNiagaService {
  // Future<List<OpenInvoiceAccesses>> getopeninvoice();
  Future<List<TrackingPtpCosdAccesses>> getTrackingPTPCOSD(
      // {String? email, int? page, int? size}
      String noPL
      );
}
