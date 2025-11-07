import 'package:flutter_riverpod/flutter_riverpod.dart';

final poseDetectionServiceProvider = Provider<PoseDetectionService>((ref) {
  return PoseDetectionService();
});

class PoseDetectionService {
  Future<double> evaluatePoseMatch() async {
    // TODO: ML Kit Pose Detection 연동
    return Future<double>.value(0.0);
  }
}

