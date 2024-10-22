import 'package:counter/provider/counter.provider.dart';
import 'package:counter/provider/theme_provider';
import 'package:counter/view/tally_set_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //String? _selectedItem;

  bool isSelected = ThemeProvider().isSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tally Sets",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        actions: _buildAppBarActions(),
      ),
      body: _buildBody(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Switch(
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              thumbColor: const WidgetStatePropertyAll(Colors.orange),
              inactiveTrackColor: Colors.transparent,
              thumbIcon: WidgetStatePropertyAll(themeProvider.isSelected
                  ? const Icon(Icons.nights_stay)
                  : const Icon(Icons.sunny)),
              value: themeProvider.isSelected,
              onChanged: (value) {
                setState(() {
                  themeProvider.toggleTheme();
                });
              },
            );
          },
        ),
      ),
    ];
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

  Widget _buildGestureDetect() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => TallySetView()));
      },
      child: Container(
        color: Colors.transparent,
        child: _buildHeader(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30, color: Colors.grey),
        _buildGestureDetect(),
      ],
    );
  }
}
