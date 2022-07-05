import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Charlie extends SpriteAnimationComponent {
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    debugMode = true;
  }
}
