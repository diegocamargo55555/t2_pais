class Pais {
  int? id;
  String nome;
  String capital;
  int populacao;
  String sigla;
  String continente;
  String regimePolitico;
  String? bandeira; // Novo campo para o caminho da imagem

  Pais({
    this.id,
    required this.nome,
    required this.capital,
    required this.populacao,
    required this.sigla,
    required this.continente,
    required this.regimePolitico,
    this.bandeira, // Adicione no construtor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'capital': capital,
      'populacao': populacao,
      'sigla': sigla,
      'continente': continente,
      'regime_politico': regimePolitico,
      'bandeira': bandeira, // Adicione no map
    };
  }

  factory Pais.fromMap(Map<String, dynamic> map) {
    return Pais(
      id: map['id'],
      nome: map['nome'],
      capital: map['capital'],
      populacao: map['populacao'],
      sigla: map['sigla'],
      continente: map['continente'],
      regimePolitico: map['regime_politico'],
      bandeira: map['bandeira'], // Recupere do map
    );
  }
}
