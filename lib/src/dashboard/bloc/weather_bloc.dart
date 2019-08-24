import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:wheather/src/model/wheather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  @override
  WeatherState get initialState => InitialWeatherState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    // TODO: Add Logic
    if (event is GetWeather) {
      yield WeatherLoading();
      final weather = await _fetchWeatherFromApi(event.cityName);
      yield WeatherLoaded(weather);
    }
  }

  Future<Weather> _fetchWeatherFromApi(String cityName) async {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        return Weather(
          cityName: cityName,
          temperature: 20 + Random().nextInt(15) + Random().nextDouble(),
        );
      }
    );
  }
}