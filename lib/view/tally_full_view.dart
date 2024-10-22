import 'package:counter/provider/counter.provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TallyFullView extends StatefulWidget {
  const TallyFullView({super.key});

  @override
  State<TallyFullView> createState() => _TallyFullViewState();
}

class _TallyFullViewState extends State<TallyFullView> {
  String _getFormattedDateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now); // Example: 21:06

    final bool isToday = now.day == DateTime.now().day &&
        now.month == DateTime.now().month &&
        now.year == DateTime.now().year;

    return isToday
        ? 'Updated: Today, $formattedTime'
        : 'Updated: ${DateFormat('EEEE').format(now)}, $formattedTime'; // Example: Monday, 21:06
  }

  @override
  Widget build(BuildContext context) {
    final countProvider =
        ModalRoute.of(context)!.settings.arguments as CountProvider;

    return Scaffold(
      appBar: _buildAppBar(countProvider),
      body: _buildBody(countProvider),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  AppBar _buildAppBar(CountProvider countProvider) {
    return AppBar(
      title: const Text("Tallies"),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              countProvider.resetCount();
            });
          },
          icon: const Icon(Icons.menu_sharp),
        ),
      ],
    );
  }

  Widget _buildBody(CountProvider countProvider) {
    return GestureDetector(
      onTap: () {
        setState(() {
          countProvider.countUp();
        });
      },
      onVerticalDragEnd: (details) {
        _handleVerticalDrag(details, countProvider);
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            '${countProvider.count}', // Display count
            style: const TextStyle(
              fontSize: 150,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handleVerticalDrag(
      DragEndDetails details, CountProvider countProvider) {
    setState(() {
      if (details.velocity.pixelsPerSecond.dy < 0) {
        countProvider.countDown();
      } else if (details.velocity.pixelsPerSecond.dy > 0) {
        countProvider.countUp();
      }
    });
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      height: 50,
      child: Center(
        child: Text(
          _getFormattedDateTime(),
        ),
      ),
    );
  }
}
