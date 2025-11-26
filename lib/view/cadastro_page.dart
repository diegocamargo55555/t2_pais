import 'package:flutter/material.dart';
import 'package:t2_pais/database/helper/pais_helper.dart';
import 'package:t2_pais/database/model/pais_model.dart';

class CadastroPaisPage extends StatefulWidget {
  final Pais? paisParaEditar;

  const CadastroPaisPage({super.key, this.paisParaEditar});

  @override
  State<CadastroPaisPage> createState() => _CadastroPaisPageState();
}

class _CadastroPaisPageState extends State<CadastroPaisPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _capitalController = TextEditingController();
  final _populacaoController = TextEditingController();
  final _siglaController = TextEditingController();

  String? _continenteSelecionado;
  String? _regimeSelecionado;

  final List<String> _continentes = [
    'África',
    'América',
    'Antártida',
    'Ásia',
    'Europa',
    'Oceania',
  ];
  final List<String> _regimes = [
    'Democracia',
    'República',
    'Monarquia',
    'Ditadura',
    'Parlamentarismo',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.paisParaEditar != null) {
      _nomeController.text = widget.paisParaEditar!.nome;
      _capitalController.text = widget.paisParaEditar!.capital;
      _populacaoController.text = widget.paisParaEditar!.populacao.toString();
      _siglaController.text = widget.paisParaEditar!.sigla;
      _continenteSelecionado = widget.paisParaEditar!.continente;
      _regimeSelecionado = widget.paisParaEditar!.regimePolitico;
    }
  }

  _salvarPais() async {
    if (_formKey.currentState!.validate()) {
      Pais pais = Pais(
        id: widget.paisParaEditar?.id,
        nome: _nomeController.text,
        capital: _capitalController.text,
        populacao: int.parse(_populacaoController.text),
        sigla: _siglaController.text,
        continente: _continenteSelecionado!,
        regimePolitico: _regimeSelecionado!,
      );

      PaisHelper db = PaisHelper();
      if (widget.paisParaEditar == null) {
        await db.CreatePais(pais);
      } else {
        await db.updatePais(pais);
      }
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.paisParaEditar == null ? 'Novo País' : 'Editar País',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _capitalController,
                decoration: const InputDecoration(labelText: 'Capital'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _populacaoController,
                decoration: const InputDecoration(labelText: 'População'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _siglaController,
                decoration: const InputDecoration(labelText: 'Sigla'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _continenteSelecionado,
                decoration: const InputDecoration(labelText: 'Continente'),
                items: _continentes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _continenteSelecionado = value),
                validator: (value) =>
                    value == null ? 'Selecione um continente' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _regimeSelecionado,
                decoration: const InputDecoration(labelText: 'Regime Político'),
                items: _regimes
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _regimeSelecionado = value),
                validator: (value) =>
                    value == null ? 'Selecione um regime' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarPais,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
