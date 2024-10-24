import 'package:counter/model/tally_item.dart';
import 'package:counter/provider/counter.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TallySetView extends StatefulWidget {
  const TallySetView({super.key});

  @override
  State<TallySetView> createState() => _TallySetViewState();
}

class _TallySetViewState extends State<TallySetView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tally Sets"),
        actions: _buildAppBarActions(provider),
      ),
      body: _buildBody(provider),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildAppBarActions(CountProvider provider) {
    return [
      IconButton(
        onPressed: () => _resetAllCounters(provider),
        icon: const Icon(Icons.remove),
      ),
      IconButton(
        onPressed: () => _addNewCounter(provider),
        icon: const Icon(Icons.add_circle),
      ),
    ];
  }

  void _resetAllCounters(CountProvider provider) {
    for (var pr in provider.items) {
      provider.resetState(pr);
    }
  }

  void _addNewCounter(CountProvider provider) async {
    await provider.addItem();
  }

  Widget _buildBody(CountProvider provider) {
    return Column(
      children: [
        _buildHeader(provider),
        const Divider(height: 30, color: Colors.grey),
        _buildTallyList(provider),
      ],
    );
  }

  Widget _buildHeader(CountProvider provider) {
    return Row(
      children: [
        const Icon(Icons.star),
        const SizedBox(width: 10),
        Text(
          provider.name,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTallyList(CountProvider provider) {
    return Expanded(
      child: ListView.builder(
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          final item = provider.items[index];
          return _buildDismissibleTallyRow(provider, index, item);
        },
      ),
    );
  }

  Widget _buildDismissibleTallyRow(
      CountProvider provider, int index, TallyItem item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _removeTallyProvider(provider, item);
      },
      background: _buildDismissBackground(),
      child: _buildTallyRow(provider, item),
    );
  }

  void _removeTallyProvider(CountProvider provider, TallyItem item) {
    provider.deleteItem(item.id!); // Pass the item's ID to delete it

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tally "${item.name}" removed'),
    ));
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.redAccent,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildTallyRow(CountProvider provider, TallyItem item) {
    return Column(
      children: [
        _buildCounterRow(provider, item),
        const Divider(height: 30, color: Colors.grey),
      ],
    );
  }

  Widget _buildCounterRow(CountProvider provider, TallyItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              provider.decrementCounter(item);
            },
            child: const Icon(Icons.remove),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                "tallyFull",
                arguments: [provider, item],
              );
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: Text(
                  '${item.count}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.incrementCounter(item);
            },
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
        final snackBarText =
            index == 0 ? 'Nothing to ADD Setting.' : 'Nothing to ADD Share.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snackBarText)),
        );
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
