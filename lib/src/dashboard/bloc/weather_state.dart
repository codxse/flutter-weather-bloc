import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wheather/src/model/wheather.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super(props);
}

class InitialWeatherState extends WeatherState {

}

class WeatherLoading extends WeatherState {

}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather) : super([weather]);
}