import '../../../model/niaga/tracking/ptp-cosd/astra-motor/tracking_astra.dart';

abstract class TrackingNiagaAstraMotorService {
  Future<List<TrackingAstraAccesses>> getTrackingAstraMotor(
      String noPL
      );
}
