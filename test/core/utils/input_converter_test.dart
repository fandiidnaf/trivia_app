import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represent an unsigned integer',
        () async {
      // arrange
      const String str = '123';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, const Right(123));
    });

    test('should return a Failure when the string is not an integer', () async {
      // arrange
      const String str = 'abc';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is negative integer',
        () async {
      // arrange
      const String str = '-1';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
