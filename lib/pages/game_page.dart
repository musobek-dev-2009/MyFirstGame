import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final String player1Symbol;
  final String player2Symbol;

  const GamePage({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.player1Symbol,
    required this.player2Symbol,
  });

  @override

  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  List<String?> _board = List.filled(9, null);
  bool _isPlayer1Turn = true;
  String? _winner;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  List<int>? _winningPattern;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.greenAccent,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (_board[index] != null || _winner != null) return;

    setState(() {
      _board[index] = _isPlayer1Turn ? widget.player1Symbol : widget.player2Symbol;
      _isPlayer1Turn = !_isPlayer1Turn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    final winningPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winningPatterns) {
      final a = _board[pattern[0]];
      final b = _board[pattern[1]];
      final c = _board[pattern[2]];
      if (a != null && a == b && a == c) {
        setState(() {
          _winner = a;
          _winningPattern = pattern;
        });
        _animationController.forward().then((_) => _animationController.reverse());
        return;
      }
    }

    if (!_board.contains(null)) {
      setState(() {
        _winner = 'Draw';
      });
      _animationController.forward().then((_) => _animationController.reverse());
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, null);
      _isPlayer1Turn = true;
      _winner = null;
      _winningPattern = null;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.player1Name} vs ${widget.player2Name}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_winner != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _winner == 'Draw' ? 'It\'s a Draw!' : '${_winner == widget.player1Symbol ? widget.player1Name : widget.player2Name} Wins!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _winner == 'Draw' ? Colors.grey : (_winner == widget.player1Symbol ? Colors.blue : Colors.red),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _winner == null ? '${_isPlayer1Turn ? widget.player1Name : widget.player2Name}\'' : '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isPlayer1Turn ? Colors.blue : Colors.green,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final isWinningCell = _winningPattern?.contains(index) ?? false;
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: isWinningCell ? _colorAnimation.value : Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text(
                            _board[index] ?? '',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _board[index] == widget.player1Symbol ? Colors.blue : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[800], 
              foregroundColor: Colors.white, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              elevation: 5,
            ),
            child: const Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}


