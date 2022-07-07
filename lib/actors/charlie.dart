import 'package:charlie_chicken/main.dart';
import 'package:charlie_chicken/world/obstacle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Charlie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ChickenGame> {
  bool chickenFlipped = false;
  bool collided = false;
  JoystickDirection collidedDirection = JoystickDirection.idle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    // debugMode = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final bool moveLeft = gameRef.joystick.direction == JoystickDirection.left;
    final bool moveRight =
        gameRef.joystick.direction == JoystickDirection.right;
    final bool moveUp = gameRef.joystick.direction == JoystickDirection.up;
    final bool moveDown = gameRef.joystick.direction == JoystickDirection.down;
    final double chickenVectorX =
        (gameRef.joystick.relativeDelta * 300 * dt)[0];
    final double chickenVectorY =
        (gameRef.joystick.relativeDelta * 300 * dt)[1];

    // chicken is moving left
    if (moveLeft && x > 0) {
      if (!collided || collidedDirection == JoystickDirection.right) {
        x += chickenVectorX;
      }
    }
// chicken is moving right
    if (moveRight && x < gameRef.size[0]) {
      if (!collided || collidedDirection == JoystickDirection.left) {
        x += chickenVectorX;
      }
    }

    // chicken s moving up
    if (moveUp && y > 0) {
      if (!collided || collidedDirection == JoystickDirection.down) {
        y += chickenVectorY;
      }
    }

    // chicken s moving down
    if (moveDown && y < gameRef.size[1] - height) {
      if (!collided || collidedDirection == JoystickDirection.up) {
        y += chickenVectorY;
      }
    }

    if (gameRef.joystick.relativeDelta[0] < 0 && chickenFlipped) {
      chickenFlipped = false;
      flipHorizontallyAroundCenter();
    }

    if (gameRef.joystick.relativeDelta[0] > 0 && !chickenFlipped) {
      chickenFlipped = true;
      flipHorizontallyAroundCenter();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      if (!collided) {
        collided = true;
        collidedDirection = gameRef.joystick.direction;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    collidedDirection = JoystickDirection.idle;
    collided = false;
  }
}
