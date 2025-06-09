import 'package:flutter/material.dart';

void main() {
  runApp(const Jogo2048App());
}

class Jogo2048App extends StatelessWidget {
  const Jogo2048App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo 2048',
      home: const Jogo2048HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Jogo2048HomePage extends StatefulWidget {
  const Jogo2048HomePage({super.key});

  @override
  State<Jogo2048HomePage> createState() => _Jogo2048HomePageState();
}

class _Jogo2048HomePageState extends State<Jogo2048HomePage> {
  int gridSize = 4;
  int movimentos = 0;
  String status = '';
  List<List<int>> grid = [];

  @override
  void initState() {
    super.initState();
    _inicializarGrid();
  }

  void _inicializarGrid() {
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => 0));
    _adicionarNovoNumero();
    _adicionarNovoNumero();
  }

  void _mudarNivel(int tamanho) {
    setState(() {
      gridSize = tamanho;
      movimentos = 0;
      status = '';
      _inicializarGrid();
    });
  }

  void _adicionarNovoNumero() {
    final vazio = <Map<String, int>>[];

    for (var i = 0; i < gridSize; i++) {
      for (var j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          vazio.add({'x': i, 'y': j});
        }
      }
    }

    if (vazio.isNotEmpty) {
      final pos = vazio[DateTime.now().millisecondsSinceEpoch % vazio.length];
      grid[pos['x']!][pos['y']!] = (DateTime.now().millisecondsSinceEpoch % 10 == 0) ? 4 : 2;
    }
  }

  void _moverParaCima() {
    setState(() {
      for (int j = 0; j < gridSize; j++) {
        List<int> coluna = [];

        for (int i = 0; i < gridSize; i++) {
          if (grid[i][j] != 0) {
            coluna.add(grid[i][j]);
          }
        }

        for (int i = 0; i < coluna.length - 1; i++) {
          if (coluna[i] == coluna[i + 1]) {
            coluna[i] *= 2;
            coluna[i + 1] = 0;
          }
        }

        coluna = coluna.where((v) => v != 0).toList();

        while (coluna.length < gridSize) {
          coluna.add(0);
        }

        for (int i = 0; i < gridSize; i++) {
          grid[i][j] = coluna[i];
        }
      }

      movimentos++;
      _adicionarNovoNumero();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo 2048'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Movimentos: $movimentos', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _mudarNivel(4), child: const Text('Nível Fácil')),
                ElevatedButton(onPressed: () => _mudarNivel(5), child: const Text('Nível Médio')),
                ElevatedButton(onPressed: () => _mudarNivel(6), child: const Text('Nível Difícil')),
              ],
            ),
            const SizedBox(height: 20),
            _buildGrid(),
            const SizedBox(height: 20),
            _buildControles(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: gridSize * gridSize,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemBuilder: (context, index) {
          int x = index ~/ gridSize;
          int y = index % gridSize;
          int valor = grid[x][y];

          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: valor == 0 ? Colors.grey[300] : Colors.orange[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                valor == 0 ? '' : '$valor',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControles() {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: _moverParaCima,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: null),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: null),
          ],
        ),
        IconButton(icon: const Icon(Icons.arrow_downward), onPressed: null),
      ],
    );
  }
}