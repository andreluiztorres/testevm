import 'dart:math';

abstract class ExamApi {
  List<int> getRandomNumbers(int quantity);
  bool checkOrder(List<int> numbers);
}

class ExamApiImpl extends ExamApi {
  @override
  List<int> getRandomNumbers(int quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }

    final random = Random();
    final numbers = <int>{};
    while (numbers.length < quantity) {
      numbers.add(random.nextInt(1000));
    }
    return numbers.toList();
  }

  @override
  bool checkOrder(List<int> numbers) {
    for (int i = 0; i < numbers.length - 1; i++) {
      if (numbers[i] > numbers[i + 1]) return false;
    }
    return true;
  }
}
