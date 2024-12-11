import 'package:flutter_test/flutter_test.dart';
import 'package:vmtesteapp/exam_api.dart';

void main() {
  final api = ExamApiImpl();

  test('getRandomNumbers returns unique numbers', () {
    final numbers = api.getRandomNumbers(5);
    expect(numbers.length, 5);
    expect(numbers.toSet().length, 5);
  });

  test('checkOrder verifies sorted order correctly', () {
    expect(api.checkOrder([1, 2, 3, 4]), true);
    expect(api.checkOrder([4, 3, 2, 1]), false);
  });
}
