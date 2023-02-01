import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/presentation/screens/weather_today_screen.dart';
import 'package:weather/presentation/constants/decorations.dart';
import 'package:weather/presentation/constants/text_styles.dart';
import 'package:weather/presentation/widgets/gap.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text("Погода", style: labelText), InputRow()],
    ));
  }
}

class InputRow extends StatelessWidget {
  InputRow({super.key});

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listenWhen: _listenWhenHandler,
      listener: _weatherListener,
      builder: _inputBuilder,
    );
  }

  bool _listenWhenHandler(previousState, state) {
    return previousState is WeatherInitial ||
        previousState is WeatherFetchingFailure;
  }

  void _weatherListener(BuildContext context, WeatherState state) {
    if (state is WeatherToday) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const WeatherTodayScreen(),
        ),
      );
    } else if (state is WeatherFetchingFailure) {
      showSnackBar(context);
    }
  }

  Widget _inputBuilder(BuildContext context, WeatherState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: myController,
              decoration: inputDecoration,
            ),
          ),
          Gap(),
          IconButton(
              onPressed: () {
                if (myController.text.isNotEmpty) {
                  context
                      .read<WeatherBloc>()
                      .add(WeatherFetching(city: myController.text));
                }
              },
              icon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 236, 111, 76),
              ))
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(minutes: 5),
      content: Text(
        'Ошибка получения данных',
        style: TextStyle(color: Colors.black.withOpacity(0.7)),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black.withOpacity(0.5)),
      ),
      action: SnackBarAction(
        textColor: const Color.fromARGB(255, 236, 111, 76),
        label: "Закрыть",
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
