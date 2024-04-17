import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fast_noise/fast_noise.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:game/game/rogalik_game.dart';

double mapRange(
    double value, double start1, double end1, double start2, double end2) {
  return start2 + (value - start1) * (end2 - start2) / (end1 - start1);
}

class BackgroundComponent extends PositionComponent
    with HasGameRef<RogalikGame> {
  Image? backgroundImage;

  @override
  void onLoad() async {
    final int width = this.gameRef.size.x.toInt() * 2;
    final int height = this.gameRef.size.y.toInt();
    final pixels = Uint32List(width * height);

    List<List<double>> noiseMap = noise2(
      width,
      height,
      noiseType: NoiseType.simplex,
      frequency: 0.1,
      octaves: 2,
      seed: Random.secure().nextInt(1024),
    );

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final noiseValue = noiseMap[x][y];
        final brightness = mapRange(noiseValue, -1, 1, 0, 255).toInt();
        pixels[y * width + x] =
            (255 << 24) | (brightness << 16) | (brightness << 8) | brightness;
      }
    }

    final completer = Completer<Image>();
    decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      width,
      height,
      PixelFormat.rgba8888,
      completer.complete,
    );

    this.backgroundImage = await completer.future;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (this.backgroundImage == null) return;

    int number_of_width =
        this.gameRef.playerComponent.position.x ~/ this.backgroundImage!.size.x;
    int number_of_height =
        this.gameRef.playerComponent.position.y ~/ this.backgroundImage!.size.y;

    if (this.gameRef.playerComponent.position.x < 0) number_of_width--;
    if (this.gameRef.playerComponent.position.y < 0) number_of_height--;

    for (int y = -1; y <= 1; y++) {
      for (int x = -1; x <= 1; x++) {
        canvas.drawImage(
            this.backgroundImage!,
            Offset((x + number_of_width).toDouble() * backgroundImage!.width,
                (y + number_of_height).toDouble() * backgroundImage!.height),
            Paint());
      }
    }
  }
}
