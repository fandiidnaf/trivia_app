import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/core/const/const.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was getten the last time
  /// the user had an internal connection
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferencesAsync preferencesAsync;

  NumberTriviaLocalDataSourceImpl(this.preferencesAsync);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = await preferencesAsync.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return NumberTriviaModel.fromJson(json.decode(jsonString));
    }
    throw CacheException();
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    return await preferencesAsync.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
