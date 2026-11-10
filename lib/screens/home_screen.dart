import 'package:flutter/material.dart';
import '../data/frases_db.dart';
import '../models/frase.dart';
import 'formulario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Frase> _frases = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await FrasesDb.instancia.obtenerTodas();
    if (!mounted) return;
    setState(() {
      _frases = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario([Frase? existente]) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FormularioScreen(frase: existente)),
    );
    if (guardado == true) {
      await _cargar();
    }
  }

  Future<void> _confirmarEliminar(Frase f) async {
    await FrasesDb.instancia.eliminar(f.id!);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Frases - SQLite')),
      body: _cargando 
        ? const Center(child: CircularProgressIndicator())
        : _frases.isEmpty
          ? const Center(child: Text('No hay frases guardadas todavía.'))
          : ListView.builder(
              itemCount: _frases.length,
              itemBuilder: (context, index) {
                final f = _frases[index];
                return ListTile(
                  title: Text(f.frase),
                  subtitle: Text('— ${f.autor}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmarEliminar(f),
                  ),
                  onTap: () => _abrirFormulario(f),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}