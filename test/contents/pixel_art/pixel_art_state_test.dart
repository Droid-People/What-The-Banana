import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_banana/contents/pixel_art/pixel_art_state.dart';

void main() {
  group('PixelArtState', () {
    test('initial state has correct defaults', () {
      final state = PixelArtState.initial();

      expect(state.arrayDeque, isEmpty);
      expect(state.gridMap, isEmpty);
      expect(state.pixelSize, 1);
      expect(state.selectedColor, Colors.black);
      expect(state.pickColorState, false);
      expect(state.showGrid, true);
    });

    group('copyWith', () {
      test('updates arrayDeque', () {
        final state = PixelArtState.initial();
        final newDeque = [Colors.red, Colors.blue, Colors.green];
        final updated = state.copyWith(arrayDeque: newDeque);

        expect(updated.arrayDeque, newDeque);
        expect(updated.gridMap, isEmpty);
        expect(updated.pixelSize, 1);
        expect(updated.selectedColor, Colors.black);
        expect(updated.pickColorState, false);
        expect(updated.showGrid, true);
      });

      test('updates gridMap', () {
        final state = PixelArtState.initial();
        final newGrid = [
          [Colors.red, Colors.blue],
          [Colors.green, Colors.yellow],
        ];
        final updated = state.copyWith(gridMap: newGrid);

        expect(updated.arrayDeque, isEmpty);
        expect(updated.gridMap, newGrid);
        expect(updated.pixelSize, 1);
      });

      test('updates pixelSize', () {
        final state = PixelArtState.initial();
        final updated = state.copyWith(pixelSize: 16);

        expect(updated.pixelSize, 16);
        expect(updated.arrayDeque, isEmpty);
        expect(updated.gridMap, isEmpty);
      });

      test('updates selectedColor', () {
        final state = PixelArtState.initial();
        final updated = state.copyWith(selectedColor: Colors.red);

        expect(updated.selectedColor, Colors.red);
        expect(updated.pixelSize, 1);
        expect(updated.pickColorState, false);
      });

      test('updates pickColorState', () {
        final state = PixelArtState.initial();
        final updated = state.copyWith(pickColorState: true);

        expect(updated.pickColorState, true);
        expect(updated.selectedColor, Colors.black);
        expect(updated.showGrid, true);
      });

      test('updates showGrid', () {
        final state = PixelArtState.initial();
        final updated = state.copyWith(showGrid: false);

        expect(updated.showGrid, false);
        expect(updated.pickColorState, false);
        expect(updated.pixelSize, 1);
      });

      test('updates multiple fields at once', () {
        final state = PixelArtState.initial();
        final newDeque = [Colors.red, Colors.blue];
        final newGrid = [[Colors.green, Colors.yellow]];

        final updated = state.copyWith(
          arrayDeque: newDeque,
          gridMap: newGrid,
          pixelSize: 8,
          selectedColor: Colors.purple,
          pickColorState: true,
          showGrid: false,
        );

        expect(updated.arrayDeque, newDeque);
        expect(updated.gridMap, newGrid);
        expect(updated.pixelSize, 8);
        expect(updated.selectedColor, Colors.purple);
        expect(updated.pickColorState, true);
        expect(updated.showGrid, false);
      });

      test('copyWith with no arguments returns equivalent state', () {
        final state = PixelArtState(
          arrayDeque: [Colors.red],
          gridMap: [[Colors.blue]],
          pixelSize: 4,
          selectedColor: Colors.green,
          pickColorState: true,
          showGrid: false,
        );
        final copied = state.copyWith();

        expect(copied.arrayDeque, state.arrayDeque);
        expect(copied.gridMap, state.gridMap);
        expect(copied.pixelSize, state.pixelSize);
        expect(copied.selectedColor, state.selectedColor);
        expect(copied.pickColorState, state.pickColorState);
        expect(copied.showGrid, state.showGrid);
      });

      test('copyWith preserves unchanged fields', () {
        final initialDeque = [Colors.red, Colors.blue];
        final initialGrid = [[Colors.green]];
        final state = PixelArtState(
          arrayDeque: initialDeque,
          gridMap: initialGrid,
          pixelSize: 8,
          selectedColor: Colors.orange,
          pickColorState: true,
          showGrid: false,
        );

        final updated = state.copyWith(pixelSize: 16);

        expect(updated.arrayDeque, initialDeque);
        expect(updated.gridMap, initialGrid);
        expect(updated.pixelSize, 16); // Changed
        expect(updated.selectedColor, Colors.orange);
        expect(updated.pickColorState, true);
        expect(updated.showGrid, false);
      });
    });

    group('complex state scenarios', () {
      test('can represent a simple 2x2 grid', () {
        final grid = [
          [Colors.red, Colors.blue],
          [Colors.green, Colors.yellow],
        ];
        final state = PixelArtState.initial().copyWith(
          gridMap: grid,
          pixelSize: 2,
        );

        expect(state.gridMap.length, 2);
        expect(state.gridMap[0].length, 2);
        expect(state.gridMap[0][0], Colors.red);
        expect(state.gridMap[1][1], Colors.yellow);
      });

      test('can store color history in arrayDeque', () {
        final history = [
          Colors.black,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
        ];
        final state = PixelArtState.initial().copyWith(arrayDeque: history);

        expect(state.arrayDeque.length, 5);
        expect(state.arrayDeque.first, Colors.black);
        expect(state.arrayDeque.last, Colors.yellow);
      });

      test('can toggle between color picking and drawing', () {
        var state = PixelArtState.initial();

        // Start in drawing mode
        expect(state.pickColorState, false);

        // Switch to color picking
        state = state.copyWith(pickColorState: true);
        expect(state.pickColorState, true);

        // Switch back to drawing
        state = state.copyWith(pickColorState: false);
        expect(state.pickColorState, false);
      });

      test('can toggle grid visibility', () {
        var state = PixelArtState.initial();

        // Grid visible by default
        expect(state.showGrid, true);

        // Hide grid
        state = state.copyWith(showGrid: false);
        expect(state.showGrid, false);

        // Show grid again
        state = state.copyWith(showGrid: true);
        expect(state.showGrid, true);
      });

      test('can represent different pixel sizes', () {
        final smallPixels = PixelArtState.initial().copyWith(pixelSize: 1);
        final mediumPixels = PixelArtState.initial().copyWith(pixelSize: 8);
        final largePixels = PixelArtState.initial().copyWith(pixelSize: 32);

        expect(smallPixels.pixelSize, 1);
        expect(mediumPixels.pixelSize, 8);
        expect(largePixels.pixelSize, 32);
      });
    });

    group('edge cases', () {
      test('empty gridMap and arrayDeque', () {
        final state = PixelArtState(
          arrayDeque: [],
          gridMap: [],
          pixelSize: 1,
          selectedColor: Colors.black,
          pickColorState: false,
          showGrid: true,
        );

        expect(state.arrayDeque, isEmpty);
        expect(state.gridMap, isEmpty);
      });

      test('single color in arrayDeque', () {
        final state = PixelArtState.initial().copyWith(
          arrayDeque: [Colors.red],
        );

        expect(state.arrayDeque.length, 1);
        expect(state.arrayDeque.first, Colors.red);
      });

      test('single pixel grid', () {
        final state = PixelArtState.initial().copyWith(
          gridMap: [[Colors.red]],
          pixelSize: 1,
        );

        expect(state.gridMap.length, 1);
        expect(state.gridMap[0].length, 1);
        expect(state.gridMap[0][0], Colors.red);
      });
    });
  });
}
