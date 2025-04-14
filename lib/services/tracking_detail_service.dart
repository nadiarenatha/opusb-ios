import 'package:niaga_apps_mobile/model/tracking_detail.dart';

abstract class TrackingDetailService {
  // Future<bool> logout();
  // ------ NEW ------
  Future<List<TrackingDetailAccesses>> gettrackingdetail(
      {int? mePackingListId});
}
