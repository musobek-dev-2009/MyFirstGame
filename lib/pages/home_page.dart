import 'package:flutter/material.dart';
import 'game_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final Function(bool) toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();

  final List<String> _symbols = List.generate(25, (index) => String.fromCharCode(65 + index));
  String _player1Symbol = 'X';
  String _player2Symbol = 'O';

  void _startGame() {
    final player1Name = _player1Controller.text;
    final player2Name = _player2Controller.text;

    if (player1Name.isEmpty || player2Name.isEmpty) {
      _showSnackBar('Please enter names for both players.');
      return;
    }

    if (player1Name.length > 10 || player2Name.length > 10) {
      _showSnackBar('Player names must not exceed 10 characters.');
      return;
    }

    if (_player1Symbol == _player2Symbol) {
      _showSnackBar('Players must choose different symbols.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          player1Name: player1Name,
          player2Name: player2Name,
          player1Symbol: _player1Symbol,
          player2Symbol: _player2Symbol,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.teal[800],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.teal[800]),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(toggleTheme: widget.toggleTheme),
                  ),
                );
              },
              tileColor: Colors.teal[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextField(_player1Controller, 'Player 1 Name'),
            const SizedBox(height: 16),
            _buildSymbolSelector('Player 1 Symbol', _player1Symbol, (value) {
              setState(() {
                _player1Symbol = value;
              });
            }),
            const SizedBox(height: 16),
            _buildTextField(_player2Controller, 'Player 2 Name'),
            const SizedBox(height: 16),
            _buildSymbolSelector('Player 2 Symbol', _player2Symbol, (value) {
              setState(() {
                _player2Symbol = value;
              });
            }),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[800], 
                foregroundColor: Colors.white, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), 
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                elevation: 5,
              ),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      maxLength: 10,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildSymbolSelector(String label, String selectedSymbol, Function(String) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: selectedSymbol,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {

                if (label == 'Player 1 Symbol') {
                  if (newValue != _player2Symbol) {
                    _player1Symbol = newValue;
                  } else {
                    _showSnackBar('Player symbols must be different.');
                    return;
                  }
                } else {
                  if (newValue != _player1Symbol) {
                    _player2Symbol = newValue;
                  } else {
                    _showSnackBar('Player symbols must be different.');
                    return;
                  }
                }
              });
              onChanged(newValue);
            }
          },
          items: _symbols.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
