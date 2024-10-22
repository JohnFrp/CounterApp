import 'package:counter/data/tally_small_data.dart';
import 'package:counter/provider/counter.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TallySetView extends StatefulWidget {
  const TallySetView({super.key});

  @override
  State<TallySetView> createState() => _TallySetViewState();
}

class _TallySetViewState extends State<TallySetView> {
  late List<CountProvider> tallyProviders;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tallyProviders =
        TallySmallData().tallyProviders; // Initialize providers here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tally Sets"),
        actions: _buildAppBarActions(),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        onPressed: _resetAllCounters,
        icon: const Icon(Icons.remove),
      ),
      IconButton(
        onPressed: _addNewCounter,
        icon: const Icon(Icons.add_circle),
      ),
    ];
  }

  void _resetAllCounters() {
    setState(() {
      for (var provider in tallyProviders) {
        provider.resetCount();
      }
    });
  }

  void _addNewCounter() {
    setState(() {
      tallyProviders.add(CountProvider()); // Add a new provider
    });
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 30, color: Colors.grey),
          _buildTallyList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.star),
        const SizedBox(width: 10),
        Text(
          CountProvider()
              .name, // Consider changing this to a meaningful property
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTallyList() {
    return Expanded(
      child: ListView.builder(
        itemCount: tallyProviders.length,
        itemBuilder: (context, index) {
          return _buildDismissibleTallyRow(index);
        },
      ),
    );
  }

  Widget _buildDismissibleTallyRow(int index) {
    return Dismissible(
      key: Key(tallyProviders[index].hashCode.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _removeTallyProvider(index);
      },
      background: _buildDismissBackground(),
      child: _buildTallyRow(tallyProviders[index]),
    );
  }

  void _removeTallyProvider(int index) {
    setState(() {
      tallyProviders.removeAt(index); // Remove from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tally removed')),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete),
    );
  }

  Widget _buildTallyRow(CountProvider countProvider) {
    return ChangeNotifierProvider.value(
      value: countProvider,
      child: Consumer<CountProvider>(
        builder: (context, countProvider, child) {
          return Column(
            children: [
              _buildCounterRow(countProvider),
              const Divider(height: 30, color: Colors.grey),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCounterRow(CountProvider countProvider) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: countProvider.countDown,
            child: const Icon(Icons.remove),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                "tallyFull",
                arguments: countProvider, // Pass specific provider
              );
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: Text(
                  '${countProvider.count}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: countProvider.countUp,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing to ADD Setting.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing to ADD Share.')),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Setting",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: "Share",
        ),
      ],
    );
  }
}
