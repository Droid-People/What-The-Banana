import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_banana/contents/counter/dual_counter_provider.dart';

void main() {
  group('DualCounterState', () {
    test('initial state has both counters at 0', () {
      final state = DualCounterState.initial();

      expect(state.left, 0);
      expect(state.right, 0);
    });

    test('copyWith updates left counter', () {
      final state = DualCounterState.initial();
      final updated = state.copyWith(left: 5);

      expect(updated.left, 5);
      expect(updated.right, 0);
    });

    test('copyWith updates right counter', () {
      final state = DualCounterState.initial();
      final updated = state.copyWith(right: 10);

      expect(updated.left, 0);
      expect(updated.right, 10);
    });

    test('copyWith updates both counters', () {
      final state = DualCounterState.initial();
      final updated = state.copyWith(left: 3, right: 7);

      expect(updated.left, 3);
      expect(updated.right, 7);
    });

    test('copyWith with no arguments returns equivalent state', () {
      final state = DualCounterState(left: 5, right: 10);
      final copied = state.copyWith();

      expect(copied.left, state.left);
      expect(copied.right, state.right);
    });
  });

  group('DualCounterNotifier', () {
    late ProviderContainer container;
    late DualCounterNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(dualCounterProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    DualCounterState readState() => container.read(dualCounterProvider);

    test('initial state is (0, 0)', () {
      expect(readState().left, 0);
      expect(readState().right, 0);
    });

    group('incrementCount1', () {
      test('increases left counter by 1', () {
        notifier.incrementCount1();

        expect(readState().left, 1);
        expect(readState().right, 0);
      });

      test('increases left counter multiple times', () {
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.incrementCount1();

        expect(readState().left, 3);
        expect(readState().right, 0);
      });
    });

    group('incrementCount2', () {
      test('increases right counter by 1', () {
        notifier.incrementCount2();

        expect(readState().left, 0);
        expect(readState().right, 1);
      });

      test('increases right counter multiple times', () {
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.incrementCount2();

        expect(readState().left, 0);
        expect(readState().right, 3);
      });
    });

    group('decrementCount1', () {
      test('decreases left counter by 1', () {
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.decrementCount1();

        expect(readState().left, 1);
        expect(readState().right, 0);
      });

      test('does not go below 0', () {
        notifier.decrementCount1();

        expect(readState().left, 0);
        expect(readState().right, 0);
      });

      test('stays at 0 when decrementing from 0', () {
        notifier.decrementCount1();
        notifier.decrementCount1();

        expect(readState().left, 0);
      });
    });

    group('decrementCount2', () {
      test('decreases right counter by 1', () {
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.decrementCount2();

        expect(readState().left, 0);
        expect(readState().right, 1);
      });

      test('does not go below 0', () {
        notifier.decrementCount2();

        expect(readState().left, 0);
        expect(readState().right, 0);
      });

      test('stays at 0 when decrementing from 0', () {
        notifier.decrementCount2();
        notifier.decrementCount2();

        expect(readState().right, 0);
      });
    });

    group('resetCount1', () {
      test('resets left counter to 0', () {
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.resetCount1();

        expect(readState().left, 0);
        expect(readState().right, 0);
      });

      test('does not affect right counter', () {
        notifier.incrementCount1();
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.resetCount1();

        expect(readState().left, 0);
        expect(readState().right, 2);
      });
    });

    group('resetCount2', () {
      test('resets right counter to 0', () {
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.resetCount2();

        expect(readState().left, 0);
        expect(readState().right, 0);
      });

      test('does not affect left counter', () {
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.incrementCount2();
        notifier.resetCount2();

        expect(readState().left, 2);
        expect(readState().right, 0);
      });
    });

    group('reset', () {
      test('resets both counters to 0', () {
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.reset();

        expect(readState().left, 0);
        expect(readState().right, 0);
      });
    });

    group('multiple operations sequence', () {
      test('complex sequence of operations', () {
        // Increment left 3 times
        notifier.incrementCount1();
        notifier.incrementCount1();
        notifier.incrementCount1();
        expect(readState().left, 3);

        // Increment right 5 times
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.incrementCount2();
        notifier.incrementCount2();
        expect(readState().right, 5);

        // Decrement left once
        notifier.decrementCount1();
        expect(readState().left, 2);

        // Reset left
        notifier.resetCount1();
        expect(readState().left, 0);
        expect(readState().right, 5);

        // Decrement right twice
        notifier.decrementCount2();
        notifier.decrementCount2();
        expect(readState().right, 3);
      });

      test('independent counter operations', () {
        // Operate on left counter
        notifier.incrementCount1();
        notifier.incrementCount1();
        expect(readState().left, 2);
        expect(readState().right, 0);

        // Operate on right counter
        notifier.incrementCount2();
        expect(readState().left, 2);
        expect(readState().right, 1);

        // Reset right, left should remain
        notifier.resetCount2();
        expect(readState().left, 2);
        expect(readState().right, 0);
      });
    });
  });
}
