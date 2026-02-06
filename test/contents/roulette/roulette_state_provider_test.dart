import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_banana/contents/roulette/roulette_state_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RouletteState', () {
    test('initial state has empty rewards and number 0', () {
      final state = RouletteState.initial();

      expect(state.rewards, isEmpty);
      expect(state.number, 0);
    });

    test('copyWith updates rewards', () {
      final state = RouletteState.initial();
      final newRewards = ['Prize 1', 'Prize 2', 'Prize 3'];
      final updated = state.copyWith(rewards: newRewards);

      expect(updated.rewards, newRewards);
      expect(updated.number, 0);
    });

    test('copyWith updates number', () {
      final state = RouletteState.initial();
      final updated = state.copyWith(number: 5);

      expect(updated.number, 5);
      expect(updated.rewards, isEmpty);
    });

    test('copyWith updates both rewards and number', () {
      final state = RouletteState.initial();
      final newRewards = ['A', 'B'];
      final updated = state.copyWith(rewards: newRewards, number: 2);

      expect(updated.rewards, newRewards);
      expect(updated.number, 2);
    });

    test('copyWith with no arguments returns equivalent state', () {
      final state = RouletteState(rewards: ['Test'], number: 3);
      final copied = state.copyWith();

      expect(copied.rewards, state.rewards);
      expect(copied.number, state.number);
    });
  });

  group('RouletteStateNotifier', () {
    late ProviderContainer container;
    late RouletteStateNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(rouletteProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    RouletteState readState() => container.read(rouletteProvider);

    test('initial state has empty rewards and number 0', () {
      expect(readState().rewards, isEmpty);
      expect(readState().number, 0);
    });

    group('setNumber', () {
      test('creates correct number of empty reward strings', () {
        notifier.setNumber(5);

        expect(readState().number, 5);
        expect(readState().rewards.length, 5);
        expect(readState().rewards, ['', '', '', '', '']);
      });

      test('creates 1 empty reward string', () {
        notifier.setNumber(1);

        expect(readState().number, 1);
        expect(readState().rewards.length, 1);
        expect(readState().rewards, ['']);
      });

      test('creates 10 empty reward strings', () {
        notifier.setNumber(10);

        expect(readState().number, 10);
        expect(readState().rewards.length, 10);
        for (final reward in readState().rewards) {
          expect(reward, '');
        }
      });

      test('updates from previous number', () {
        notifier.setNumber(3);
        expect(readState().rewards.length, 3);

        notifier.setNumber(7);
        expect(readState().number, 7);
        expect(readState().rewards.length, 7);
      });
    });

    group('setRewards', () {
      test('sets rewards list correctly', () {
        final rewards = ['Prize 1', 'Prize 2', 'Prize 3'];
        notifier.setRewards(rewards);

        expect(readState().rewards, rewards);
      });

      test('replaces existing rewards', () {
        notifier.setRewards(['Old 1', 'Old 2']);
        expect(readState().rewards, ['Old 1', 'Old 2']);

        notifier.setRewards(['New 1', 'New 2', 'New 3']);
        expect(readState().rewards, ['New 1', 'New 2', 'New 3']);
      });

      test('sets empty rewards list', () {
        notifier.setRewards(['A', 'B']);
        notifier.setRewards([]);

        expect(readState().rewards, isEmpty);
      });
    });

    group('setNumber then setRewards sequence', () {
      test('typical workflow: set number then fill rewards', () {
        // Set number to create empty reward slots
        notifier.setNumber(3);
        expect(readState().number, 3);
        expect(readState().rewards, ['', '', '']);

        // Fill in the rewards
        final rewards = ['Gold', 'Silver', 'Bronze'];
        notifier.setRewards(rewards);
        expect(readState().rewards, rewards);
        expect(readState().number, 3);
      });

      test('set number with different value after setting rewards', () {
        notifier.setNumber(4);
        notifier.setRewards(['A', 'B', 'C', 'D']);

        // Change number - should create new empty rewards
        notifier.setNumber(2);
        expect(readState().number, 2);
        expect(readState().rewards, ['', '']);
      });

      test('rewards can be longer than number', () {
        notifier.setNumber(2);
        expect(readState().rewards.length, 2);

        // Set rewards with more items than number
        notifier.setRewards(['A', 'B', 'C', 'D', 'E']);
        expect(readState().rewards.length, 5);
        expect(readState().number, 2);
      });
    });

    group('edge cases', () {
      test('setNumber with 0', () {
        notifier.setNumber(0);

        expect(readState().number, 0);
        expect(readState().rewards, isEmpty);
      });

      test('multiple setNumber calls', () {
        notifier.setNumber(3);
        notifier.setNumber(5);
        notifier.setNumber(2);

        expect(readState().number, 2);
        expect(readState().rewards.length, 2);
      });
    });
  });
}
