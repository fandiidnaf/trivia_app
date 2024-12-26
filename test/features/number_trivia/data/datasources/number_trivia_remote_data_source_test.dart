import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late NumberTriviaRemoteDataSource dataSource;
  late Dio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockDio);
  });

  void setUpMockDioSuccess200() {
    final expectedMap = json.decode(fixture('trivia.json'));

    when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: expectedMap,
        statusCode: 200,
      ),
    );
  }

  void setUpMockDioFailure404() {
    when(() => mockDio.get(any(), options: any(named: 'options'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        // data: expectedMap,
        statusMessage: 'Something went wrong',
        statusCode: 404,
      ),
    );
  }

  group('getNumberTrivia', () {
    const int tNumber = 1;
    final expectedMap = json.decode(fixture('trivia.json'));
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(expectedMap);

    test('''should perform a GET request on a URL with number being a endpoint
     and with application/json header''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(
        () => mockDio.get(
          'http://numbersapi.com/$tNumber',
          options: any(
            named: 'options',
            that: isA<Options>().having(
              (e) => e.headers,
              'headers',
              {
                'Content-Type': 'application/json',
              },
            ),
          ),
        ),
      ).called(1);
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final expectedMap = json.decode(fixture('trivia.json'));
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(expectedMap);

    test('''should perform a GET request on a URL with number being a endpoint
     and with application/json header''', () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      await dataSource.getRandomNumberTrivia();

      // assert
      verify(
        () => mockDio.get(
          'http://numbersapi.com/random',
          options: any(
            named: 'options',
            that: isA<Options>().having(
              (e) => e.headers,
              'headers',
              {
                'Content-Type': 'application/json',
              },
            ),
          ),
        ),
      ).called(1);
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockDioSuccess200();

      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockDioFailure404();

      // act
      call() async => await dataSource.getRandomNumberTrivia();

      // assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });
}
