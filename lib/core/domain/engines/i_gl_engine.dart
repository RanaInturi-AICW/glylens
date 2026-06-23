import '../value_objects/gl_value.dart';
import '../value_objects/gi_value.dart';

abstract class IGLEngine {
  Future<GLValue> calculateGl({
    required GIValue giValue,
    required int availableCarbohydrates,
  });
}
