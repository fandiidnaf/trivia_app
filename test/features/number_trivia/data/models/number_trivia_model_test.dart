import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: 1, text: "test text");

  test('should be a subclass of NumberTrivia enitity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // act
      final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'should return a valid model when the JSON number is regarded as a double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containg the proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();

      final Map<String, dynamic> expectedMap = {
        "text": "test text",
        "number": 1,
      };

      // assert
      expect(result, expectedMap);
    });
  });
}
