import 'package:counter/model/tally_item.dart';
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
    final formattedTime = DateFormat('HH:mm').format(now);

    final bool isToday = now.day == DateTime.now().day &&
        now.month == DateTime.now().month &&
        now.year == DateTime.now().year;

    return isToday
        ? 'Updated: Today, $formattedTime'
        : 'Updated: ${DateFormat('EEEE').format(now)}, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    // Ensure proper typing for the arguments
    final List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final CountProvider provider = args[0];
    final TallyItem item = args[1];

    return Scaffold(
      appBar: _buildAppBar(item, provider),
      body: _buildBody(item, provider),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  AppBar _buildAppBar(TallyItem tallyItem, CountProvider provider) {
    return AppBar(
      title: const Text("Tallies"),
      actions: [
        IconButton(
          onPressed: () {
            provider.resetState(tallyItem);
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildBody(TallyItem tallyItem, CountProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.incrementCounter(tallyItem);
        setState(() {}); // Trigger UI update
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            '${tallyItem.count}', // Display updated count
            style: const TextStyle(
              fontSize: 150,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
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
