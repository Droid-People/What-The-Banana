import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_state_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GhostLegState', () {
    test('initial state has empty names, rewards, and number 0', () {
      final state = GhostLegState.initial();

      expect(state.names, isEmpty);
      expect(state.rewards, isEmpty);
      expect(state.number, 0);
    });

    test('copyWith updates names', () {
      final state = GhostLegState.initial();
      final newNames = ['Alice', 'Bob', 'Charlie'];
      final updated = state.copyWith(names: newNames);

      expect(updated.names, newNames);
      expect(updated.rewards, isEmpty);
      expect(updated.number, 0);
    });

    test('copyWith updates rewards', () {
      final state = GhostLegState.initial();
      final newRewards = ['Prize 1', 'Prize 2'];
      final updated = state.copyWith(rewards: newRewards);

      expect(updated.names, isEmpty);
      expect(updated.rewards, newRewards);
      expect(updated.number, 0);
    });

    test('copyWith updates number', () {
      final state = GhostLegState.initial();
      final updated = state.copyWith(number: 5);

      expect(updated.number, 5);
      expect(updated.names, isEmpty);
      expect(updated.rewards, isEmpty);
    });

    test('copyWith updates all fields', () {
      final state = GhostLegState.initial();
      final newNames = ['A', 'B'];
      final newRewards = ['X', 'Y'];
      final updated = state.copyWith(
        names: newNames,
        rewards: newRewards,
        number: 2,
      );

      expect(updated.names, newNames);
      expect(updated.rewards, newRewards);
      expect(updated.number, 2);
    });

    test('copyWith with no arguments returns equivalent state', () {
      final state = GhostLegState(
        names: ['Test'],
        rewards: ['Prize'],
        number: 3,
      );
      final copied = state.copyWith();

      expect(copied.names, state.names);
      expect(copied.rewards, state.rewards);
      expect(copied.number, state.number);
    });
  });

  group('GhostLegStateNotifier', () {
    late GhostLegStateNotifier notifier;

    setUp(() {
      notifier = GhostLegStateNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state has empty names, rewards, and number 0', () {
      expect(notifier.state.names, isEmpty);
      expect(notifier.state.rewards, isEmpty);
      expect(notifier.state.number, 0);
    });

    group('setNumber', () {
      test('creates correct number of empty strings for both names and rewards', () {
        notifier.setNumber(4);

        expect(notifier.state.number, 4);
        expect(notifier.state.names.length, 4);
        expect(notifier.state.rewards.length, 4);
        expect(notifier.state.names, ['', '', '', '']);
        expect(notifier.state.rewards, ['', '', '', '']);
      });

      test('creates 1 empty string each', () {
        notifier.setNumber(1);

        expect(notifier.state.number, 1);
        expect(notifier.state.names.length, 1);
        expect(notifier.state.rewards.length, 1);
        expect(notifier.state.names, ['']);
        expect(notifier.state.rewards, ['']);
      });

      test('creates 10 empty strings each', () {
        notifier.setNumber(10);

        expect(notifier.state.number, 10);
        expect(notifier.state.names.length, 10);
        expect(notifier.state.rewards.length, 10);
        for (final name in notifier.state.names) {
          expect(name, '');
        }
        for (final reward in notifier.state.rewards) {
          expect(reward, '');
        }
      });

      test('updates from previous number', () {
        notifier.setNumber(3);
        expect(notifier.state.names.length, 3);
        expect(notifier.state.rewards.length, 3);

        notifier.setNumber(5);
        expect(notifier.state.number, 5);
        expect(notifier.state.names.length, 5);
        expect(notifier.state.rewards.length, 5);
      });
    });

    group('setNames', () {
      test('sets names list correctly', () {
        final names = ['Alice', 'Bob', 'Charlie'];
        notifier.setNames(names);

        expect(notifier.state.names, names);
      });

      test('replaces existing names', () {
        notifier.setNames(['Old1', 'Old2']);
        expect(notifier.state.names, ['Old1', 'Old2']);

        notifier.setNames(['New1', 'New2', 'New3']);
        expect(notifier.state.names, ['New1', 'New2', 'New3']);
      });

      test('does not affect rewards', () {
        notifier.setRewards(['Prize1', 'Prize2']);
        notifier.setNames(['Alice', 'Bob']);

        expect(notifier.state.names, ['Alice', 'Bob']);
        expect(notifier.state.rewards, ['Prize1', 'Prize2']);
      });

      test('sets empty names list', () {
        notifier.setNames(['A', 'B']);
        notifier.setNames([]);

        expect(notifier.state.names, isEmpty);
      });
    });

    group('setRewards', () {
      test('sets rewards list correctly', () {
        final rewards = ['Gold', 'Silver', 'Bronze'];
        notifier.setRewards(rewards);

        expect(notifier.state.rewards, rewards);
      });

      test('replaces existing rewards', () {
        notifier.setRewards(['Old1', 'Old2']);
        expect(notifier.state.rewards, ['Old1', 'Old2']);

        notifier.setRewards(['New1', 'New2', 'New3']);
        expect(notifier.state.rewards, ['New1', 'New2', 'New3']);
      });

      test('does not affect names', () {
        notifier.setNames(['Alice', 'Bob']);
        notifier.setRewards(['Prize1', 'Prize2']);

        expect(notifier.state.names, ['Alice', 'Bob']);
        expect(notifier.state.rewards, ['Prize1', 'Prize2']);
      });

      test('sets empty rewards list', () {
        notifier.setRewards(['A', 'B']);
        notifier.setRewards([]);

        expect(notifier.state.rewards, isEmpty);
      });
    });

    group('full workflow: setNumber → setNames → setRewards', () {
      test('typical usage workflow', () {
        // Step 1: Set number to create empty slots
        notifier.setNumber(3);
        expect(notifier.state.number, 3);
        expect(notifier.state.names, ['', '', '']);
        expect(notifier.state.rewards, ['', '', '']);

        // Step 2: Fill in names
        final names = ['Player 1', 'Player 2', 'Player 3'];
        notifier.setNames(names);
        expect(notifier.state.names, names);
        expect(notifier.state.rewards, ['', '', '']);

        // Step 3: Fill in rewards
        final rewards = ['1st Place', '2nd Place', '3rd Place'];
        notifier.setRewards(rewards);
        expect(notifier.state.names, names);
        expect(notifier.state.rewards, rewards);
        expect(notifier.state.number, 3);
      });

      test('changing number after setting names and rewards', () {
        notifier.setNumber(4);
        notifier.setNames(['A', 'B', 'C', 'D']);
        notifier.setRewards(['W', 'X', 'Y', 'Z']);

        // Change number - should reset to empty strings
        notifier.setNumber(2);
        expect(notifier.state.number, 2);
        expect(notifier.state.names, ['', '']);
        expect(notifier.state.rewards, ['', '']);
      });

      test('names and rewards can differ in length from number', () {
        notifier.setNumber(3);

        // Set different length lists
        notifier.setNames(['A', 'B']);
        notifier.setRewards(['X', 'Y', 'Z', 'W']);

        expect(notifier.state.number, 3);
        expect(notifier.state.names.length, 2);
        expect(notifier.state.rewards.length, 4);
      });
    });

    group('edge cases', () {
      test('setNumber with 0', () {
        notifier.setNumber(0);

        expect(notifier.state.number, 0);
        expect(notifier.state.names, isEmpty);
        expect(notifier.state.rewards, isEmpty);
      });

      test('multiple setNumber calls', () {
        notifier.setNumber(3);
        notifier.setNumber(5);
        notifier.setNumber(2);

        expect(notifier.state.number, 2);
        expect(notifier.state.names.length, 2);
        expect(notifier.state.rewards.length, 2);
      });

      test('independent operations', () {
        notifier.setNames(['Alice']);
        expect(notifier.state.names, ['Alice']);
        expect(notifier.state.rewards, isEmpty);

        notifier.setRewards(['Prize']);
        expect(notifier.state.names, ['Alice']);
        expect(notifier.state.rewards, ['Prize']);

        notifier.setNumber(1);
        expect(notifier.state.names, ['']);
        expect(notifier.state.rewards, ['']);
      });
    });
  });
}
