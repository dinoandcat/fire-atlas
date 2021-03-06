import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:tinycolor/tinycolor.dart';

class CanvasSprite extends StatelessWidget {
  final Sprite sprite;
  final double translateX;
  final double translateY;
  final double scale;
  final double tileWidth;
  final double tileHeight;
  final Offset selectionStart;
  final Offset selectionEnd;

  CanvasSprite({
    this.sprite,
    this.translateX,
    this.translateY,
    this.scale,
    this.tileWidth,
    this.tileHeight,
    this.selectionStart,
    this.selectionEnd,
  });

  @override
  Widget build(ctx) {
    return Container(
        child: CustomPaint(painter: _CanvasSpritePainer(
            sprite,
            translateX,
            translateY,
            scale,
            tileWidth,
            tileHeight,
            selectionStart,
            selectionEnd,

            Theme.of(ctx).primaryColor,
            Theme.of(ctx).dividerColor,
        )),
    );
  }
}

class _CanvasSpritePainer extends CustomPainter {
  final Sprite _sprite;
  final double _x;
  final double _y;
  final double _scale;
  final double _tileWidth;
  final double _tileHeight;
  final Offset _selectionStart;
  final Offset _selectionEnd;

  Color _selectionColor;
  Color _gridTileColor;

  _CanvasSpritePainer(
      this._sprite,
      this._x,
      this._y,
      this._scale,


      this._tileWidth,
      this._tileHeight,
      this._selectionStart,
      this._selectionEnd,
      this._selectionColor,
      this._gridTileColor,
  );

  @override
  bool shouldRepaint(_CanvasSpritePainer old) =>
    old._sprite != _sprite ||
    old._x != _x ||
    old._y != _y ||
    old._scale != _scale ||
    old._selectionStart != _selectionStart ||
    old._selectionEnd != _selectionEnd;

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..color = TinyColor(
              _gridTileColor.withOpacity(1)
          ).lighten(60).color
    );

    canvas.save();
    canvas.translate(_x, _y);
    canvas.scale(_scale, _scale);

    final spriteRect = Rect.fromLTWH(
        0,
        0,
        _sprite.size.x,
        _sprite.size.y,
    );

    // Background outline
    canvas.drawRect(
        spriteRect.inflate(1.0),
        Paint()
          ..color = TinyColor(
              _gridTileColor.withOpacity(1)
          ).lighten(20).color
    );

    // Checker board
    final rowCount = (_sprite.size.y / _tileHeight).ceil();
    final columnCount = (_sprite.size.x / _tileWidth).ceil();

    final darkTilePaint = Paint()
        ..color = TinyColor(_gridTileColor.withOpacity(1)).lighten(70).color;
    final lightTilePaint = Paint()
        ..color = TinyColor(_gridTileColor.withOpacity(1)).lighten(90).color;

    for (var y = 0.0; y < rowCount; y++) {
      final m = y % 2;
      final p1 =  m == 0 ? darkTilePaint : lightTilePaint;
      final p2 =  m == 0 ? lightTilePaint : darkTilePaint;

      for (var x = 0.0; x < columnCount; x++) {
        canvas.drawRect(
            Rect.fromLTWH(x * _tileWidth, y * _tileHeight, _tileWidth, _tileHeight),
            x % 2 == 0 ? p1 : p2
        );
      }
    }

    // Sprite itself
    _sprite.renderRect(canvas, spriteRect);

    // Selection
    if (_selectionStart != null && _selectionEnd != null) {
      final size = _selectionEnd - _selectionStart + Offset(1, 1);
      canvas.drawRect(
          Rect.fromLTWH(
              (_selectionStart.dx * _tileWidth),
              (_selectionStart.dy * _tileHeight),
              (size.dx * _tileWidth),
              (size.dy * _tileHeight),
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = _selectionColor,
      );
    }

    canvas.restore();
  }
}
