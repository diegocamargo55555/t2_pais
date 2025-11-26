import 'package:flutter/material.dart';
import 'package:t2_pais/database/helper/pais_helper.dart';
import 'package:t2_pais/database/model/pais_model.dart';
import 'package:t2_pais/view/cadastro_page.dart';

class PaisPage extends StatefulWidget {
  const PaisPage({super.key});

  @override
  State<PaisPage> createState() => _PaisPageState();
}

class _PaisPageState extends State<PaisPage> {
  late PaisHelper dbPais;
  List<Pais> listaPaises = [];

  @override
  void initState() {
    super.initState();
    dbPais = PaisHelper();
    _atualizarLista();
  }

  _atualizarLista() async {
    List<Pais> x = await dbPais.getPaises();
    setState(() {
      listaPaises = x;
    });
  }

  _deletarPais(int id) async {
    await dbPais.deletePais(id);
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Países'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? saved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroPaisPage()),
          );
          if (saved == true) _atualizarLista();
        },
      ),
      body: listaPaises.isEmpty
          ? const Center(child: Text('Nenhum país cadastrado.'))
          : ListView.builder(
              itemCount: listaPaises.length,
              itemBuilder: (context, index) {
                Pais p = listaPaises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text('${p.nome} (${p.sigla})'),
                    subtitle: Text('Capital: ${p.capital} | ${p.continente}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            bool? edited = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CadastroPaisPage(paisParaEditar: p),
                              ),
                            );
                            if (edited == true) _atualizarLista();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Excluir'),
                                content: Text('Deseja excluir ${p.nome}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deletarPais(p.id!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
