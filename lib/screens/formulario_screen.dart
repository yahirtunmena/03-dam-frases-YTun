import 'package:flutter/material.dart';
import '../data/frases_db.dart';
import '../models/frase.dart';

class FormularioScreen extends StatefulWidget {
  final Frase? frase;
  const FormularioScreen({super.key, this.frase});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fraseCtrl;
  late final TextEditingController _autorCtrl;
  bool get _esEdicion => widget.frase != null;

  @override
  void initState() {
    super.initState();
    _fraseCtrl = TextEditingController(text: widget.frase?.frase ?? '');
    _autorCtrl = TextEditingController(text: widget.frase?.autor ?? '');
  }

  @override
  void dispose() {
    _fraseCtrl.dispose();
    _autorCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final frase = Frase(
      id: widget.frase?.id,
      frase: _fraseCtrl.text.trim(),
      autor: _autorCtrl.text.trim(),
    );

    if (_esEdicion) {
      await FrasesDb.instancia.actualizar(frase);
    } else {
      await FrasesDb.instancia.insert(frase);
    }
    
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar Frase' : 'Nueva Frase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fraseCtrl,
                decoration: const InputDecoration(labelText: 'Frase'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _autorCtrl,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}