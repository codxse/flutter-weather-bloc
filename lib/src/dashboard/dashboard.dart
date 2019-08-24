import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheather/src/model/wheather.dart';
import 'package:wheather/src/dashboard/bloc/bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  WeatherPage({Key key}) : super(key: key);

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherBloc weatherBloc = WeatherBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Weather App"),
      ),
      body: BlocProvider(
        builder: (BuildContext context) => weatherBloc,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocListener(
            bloc: weatherBloc,
            listener: (BuildContext context, WeatherState state) {
              if (state is WeatherLoaded) {
                print("loaded: ${state.weather.cityName}");
              }
            },
            child: BlocBuilder(
              bloc: weatherBloc,
              builder: (BuildContext context, WeatherState state) {
                if (state is InitialWeatherState) {
                  return buildInitialInput();
                } else if (state is WeatherLoading) {
                  return buildLoading();
                } else if (state is WeatherLoaded) {
                  return buildColumnWithData(state.weather);
                }
                return Text('Not found');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${weather.temperature.toStringAsPrecision(4)}",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }

  dispose() {
    super.dispose();
    weatherBloc.dispose();
  }
}

class CityInputField extends StatefulWidget {
  const CityInputField({
    Key key,
  }) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: submitCityName,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(String cityName) {
    // We will use the city name to search for the fake forecast
    final WeatherBloc weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.dispatch(GetWeather(cityName));
  }
}
