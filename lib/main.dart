import 'package:charlie_chicken/actors/charlie.dart';
import 'package:charlie_chicken/actors/fruit.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:tiled/tiled.dart';

void main() {
  print('Setup game orientation');
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  print('1.Load the GameWidget');
  runApp(GameWidget(game: ChickenGame()));
}

class ChickenGame extends FlameGame with HasDraggables, HasCollisionDetection {
  double chickenScaleFactor = 3.0;
  late final JoystickComponent joystick;
  late Charlie chicken;
  bool chickenFlipped = false;
  late SpriteComponent background;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    print("2.Load the assets for the game");
    print("3.Load the map");

    var homeMap = await TiledComponent.load('level_1.tmx', Vector2(16, 16));

    print("4. Add map to game");
    add(homeMap);

    double mapHeight = 16.0 * homeMap.tileMap.map.height;

    // get fruit
    final List<TiledObject> fruitObjects =
        homeMap.tileMap.getLayer<ObjectGroup>('Fruit')!.objects;

    for (final fruit in fruitObjects) {
      add(Fruit(fruit));
    }

    Image chickenImage = await images.load('chicken.png');

    camera.viewport = FixedResolutionViewport(Vector2(1280, mapHeight));
    print("5. load charlia chicken image ");

    var chickenAnimation = SpriteAnimation.fromFrameData(
        chickenImage,
        SpriteAnimationData.sequenced(
            amount: 14, stepTime: 0.1, textureSize: Vector2(32, 34)));
    chicken = Charlie()
      ..animation = chickenAnimation
      ..size = Vector2(32, 34) * chickenScaleFactor
      ..position = Vector2(300, 100);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    add(chicken);
    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool moveLeft = joystick.relativeDelta[0] < 0;
    bool moveRight = joystick.relativeDelta[0] > 0;
    bool moveUp = joystick.relativeDelta[1] < 0;
    bool moveDown = joystick.relativeDelta[1] > 0;
    double chickenVectorX = (joystick.relativeDelta * 300 * dt)[0];
    double chickenVectorY = (joystick.relativeDelta * 300 * dt)[1];
    //  chicken.position.add(joystick.relativeDelta * 300 * dt);

// chicken is moving horizontally
    if ((moveLeft && chicken.x > 0) || (moveRight && chicken.x < size[0])) {
      chicken.position.add(Vector2(chickenVectorX, 0));
    }

//chicken is moving vertcailly
    if ((moveUp && chicken.y > 0) ||
        (moveDown && chicken.y < size[1] - chicken.height)) {
      chicken.position.add(Vector2(0, chickenVectorY));
    }

    if (joystick.relativeDelta[0] < 0 && chickenFlipped) {
      chickenFlipped = false;
      chicken.flipHorizontallyAroundCenter();
    }

    if (joystick.relativeDelta[0] > 0 && !chickenFlipped) {
      chickenFlipped = true;
      chicken.flipHorizontallyAroundCenter();
    }
  }
}
