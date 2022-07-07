import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tiled/tiled.dart';

class Obstacle extends PositionComponent {
  final TiledObject obstacle;

  Obstacle(this.obstacle);
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
    position = Vector2(obstacle.x, obstacle.y);
    size = Vector2(obstacle.width, obstacle.height);
    add(RectangleHitbox());
  }
}
