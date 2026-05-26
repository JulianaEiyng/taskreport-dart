// ============================================================
// Meu mini projeto do SENAI - Semana 07
// Juliana Eiyng
// ============================================================

// ============================================================
// Dados das tarefas simulando o que viria de uma API
// List<Map<String, dynamic>> = lista de mapas com chave e valor
// Alguns dados estao errados de proposito, como nulos, espaços e textos
// ============================================================
final List<Map<String, dynamic>> dadosTarefas = [
  {
    'id': 1,
    'titulo': ' Corrigir bug login ',
    'responsavel': 'juliana',
    'status': 'concluida',
    'prioridade': 'alta',
    'valor': r'R$ 120,00',
    'horas': '2',
  },
  {
    'id': 2,
    'titulo': 'Criar tela de perfil',
    'responsavel': ' kelvin ',
    'status': 'em andamento',
    'prioridade': 'media',
    'valor': r'R$ 250,50',
    'horas': '5',
  },
  {
    'id': 3,
    'titulo': null, // titulo nulo - dado incompleto
    'responsavel': 'Carol',
    'status': 'pendente',
    'prioridade': 'baixa',
    'valor': r'R$ 80,00',
    'horas': null, // horas nulas - dado incompleto
  },
  {
    'id': 4,
    'titulo': ' Ajustar navegação ',
    'responsavel': null, // responsável nulo - dado incompleto
    'status': 'concluida',
    'prioridade': 'alta',
    'valor': r'R$ 150,75',
    'horas': '3',
  },
  {
    'id': 5,
    'titulo': 'Revisar regras de negócio',
    'responsavel': 'Daivid',
    'status': 'cancelada',
    'prioridade': 'media',
    'valor': r'R$ 0,00',
    'horas': '0',
  },
  {
    'id': 6,
    'titulo': 'Implementar validação de dados',
    'responsavel': 'Fátima',
    'status': 'concluida',
    'prioridade': 'alta',
    'valor': r'R$ 200,00',
    'horas': '4',
  },
  {
    'id': 7,
    'titulo': 'Organizar documentação',
    'responsavel': 'Felipe',
    'status': 'pendente',
    'prioridade': 'baixa',
    'valor': r'R$ 90,00',
    'horas': '2',
  },
];

// ============================================================
// Classe principal com os dados basicos
// Contém os atributos comuns: id e titulo
// O método exibirResumo() será sobrescrito pela classe filha
// ============================================================
class ItemTrabalho {
  int id;
  String titulo;

  // Construtor da classe base
  ItemTrabalho({
    required this.id,
    required this.titulo,
  });

  // Método que será reescrito pela classe filha (polimorfismo)
  void exibirResumo() {
    print('Item $id - $titulo');
  }
}

// ============================================================
// CLASSE FILHA - Tarefa (herda de ItemTrabalho com "extends")
// Adiciona os campos específicos de uma tarefa
// ============================================================
class Tarefa extends ItemTrabalho {
  String responsavel;
  String status;
  String prioridade;
  double valor;
  int horas;

  // Construtor da classe filha
  // Usa super() para passar id e titulo para a classe base
  Tarefa({
    required int id,
    required String titulo,
    required this.responsavel,
    required this.status,
    required this.prioridade,
    required this.valor,
    required this.horas,
  }) : super(id: id, titulo: titulo);

  // @override sobrescreve o método da classe base (polimorfismo)
  @override
  void exibirResumo() {
    print('Tarefa $id - $titulo | Status: $status | Valor: R\$ $valor');
  }
}

// ============================================================
// Classe que gera o relatorio das tarefas
// O atributo _tarefas é privado (começa com _)
// Para pegar os dados uso os getters
// ============================================================
class RelatorioTarefas {
  // Atributo privado - não pode ser acessado diretamente de fora
  final List<Tarefa> _tarefas;

  // Construtor
  RelatorioTarefas(List<Tarefa> tarefas) : _tarefas = tarefas;

  // Getters - forma controlada de acessar os dados privados
  int get quantidadeTotal => _tarefas.length;

  List<Tarefa> get tarefas => _tarefas;

  // Retorna tarefas filtradas por status
  List<Tarefa> porStatus(String status) {
    return _tarefas.where((t) => t.status == status).toList();
  }

  // Soma os valores das tarefas concluídas
  double get totalConcluidas {
    return _tarefas
        .where((t) => t.status == 'concluida')
        .fold(0.0, (soma, t) => soma + t.valor);
  }

  // Calcula a média de valor das tarefas pendentes
  double get mediaPendentes {
    final pendentes = _tarefas.where((t) => t.status == 'pendente').toList();
    if (pendentes.isEmpty) return 0.0;
    final soma = pendentes.fold(0.0, (s, t) => s + t.valor);
    return soma / pendentes.length;
  }

  // Calcula total de horas agrupado por status usando Map
  Map<String, int> get horasPorStatus {
    Map<String, int> mapa = {};
    for (var tarefa in _tarefas) {
      // Se o status já existe no mapa, soma as horas; senão, começa do zero
      mapa[tarefa.status] = (mapa[tarefa.status] ?? 0) + tarefa.horas;
    }
    return mapa;
  }

  // Retorna os status únicos usando Set (sem repetição)
  Set<String> get statusUnicos {
    return _tarefas.map((t) => t.status).toSet();
  }

  // Identifica tarefas com dados incompletos na lista original
  List<Map<String, dynamic>> get tarefasIncompletas {
    return dadosTarefas.where((item) {
      bool tituloNulo = item['titulo'] == null;
      bool responsavelNulo = item['responsavel'] == null;
      bool horasNulas = item['horas'] == null;
      bool statusVazio = item['status'] == null || item['status'].toString().trim().isEmpty;
      return tituloNulo || responsavelNulo || horasNulas || statusVazio;
    }).toList();
  }
}

// ============================================================
// FUNÇÕES DE CONVERSÃO
// ============================================================

// RF04 - Converte "R$ 120,00" para 120.0 (double)
double converterValor(dynamic valor) {
  if (valor == null) return 0.0;

  String valorTexto = valor.toString();
  // Remove "R$", espaços e troca vírgula por ponto
  valorTexto = valorTexto.replaceAll('R\$', '');
  valorTexto = valorTexto.replaceAll(' ', '');
  valorTexto = valorTexto.replaceAll(',', '.');

  return double.tryParse(valorTexto) ?? 0.0;
}

// RF05 - Converte "2" (texto) ou null para 2 (int)
int converterHoras(dynamic horas) {
  if (horas == null) return 0;
  return int.tryParse(horas.toString()) ?? 0;
}

// RF01 - Transforma um Map da lista em um objeto Tarefa
// RF02 - Trata campos nulos com ?? (operador de nulo)
// RF03 - Remove espaços com trim()
Tarefa converterMapParaTarefa(Map<String, dynamic> item) {
  return Tarefa(
    id: item['id'],
    titulo: (item['titulo'] ?? 'Sem título').toString().trim(),
    responsavel: (item['responsavel'] ?? 'Não informado').toString().trim(),
    status: (item['status'] ?? 'sem status').toString().trim(),
    prioridade: (item['prioridade'] ?? 'sem prioridade').toString().trim(),
    valor: converterValor(item['valor']),
    horas: converterHoras(item['horas']),
  );
}

// ============================================================
// FUNÇÃO PRINCIPAL - main()
// Ponto de entrada do programa Dart
// ============================================================
void main() {
  // RF01 - Transforma todos os mapas em objetos Tarefa usando map()
  final List<Tarefa> tarefas = dadosTarefas.map(converterMapParaTarefa).toList();

  // Cria o relatório com encapsulamento
  final relatorio = RelatorioTarefas(tarefas);

  // ============================================================
  // RF06 - Exibe todas as tarefas convertidas
  // ============================================================
  print('');
  print('========== TAREFAS CONVERTIDAS ==========');
  for (var tarefa in relatorio.tarefas) {
    print('');
    print('ID: ${tarefa.id}');
    print('Título: ${tarefa.titulo}');
    print('Responsável: ${tarefa.responsavel}');
    print('Status: ${tarefa.status}');
    print('Prioridade: ${tarefa.prioridade}');
    print('Valor: R\$ ${tarefa.valor}');
    print('Horas: ${tarefa.horas}');
  }

  // ============================================================
  // RF07 - Filtra tarefas por status
  // ============================================================
  print('');
  print('========== TAREFAS POR STATUS ==========');

  final concluidas = relatorio.porStatus('concluida');
  print('');
  print('Tarefas concluídas:');
  for (var t in concluidas) {
    print('- ${t.titulo}');
  }

  final emAndamento = relatorio.porStatus('em andamento');
  print('');
  print('Tarefas em andamento:');
  for (var t in emAndamento) {
    print('- ${t.titulo}');
  }

  final pendentes = relatorio.porStatus('pendente');
  print('');
  print('Tarefas pendentes:');
  for (var t in pendentes) {
    print('- ${t.titulo}');
  }

  final canceladas = relatorio.porStatus('cancelada');
  print('');
  print('Tarefas canceladas:');
  for (var t in canceladas) {
    print('- ${t.titulo}');
  }

  // ============================================================
  // RF08 - Soma valores das tarefas concluídas
  // ============================================================
  print('');
  print('========== VALORES ==========');
  print('Total de tarefas concluídas: R\$ ${relatorio.totalConcluidas}');

  // ============================================================
  // RF09 - Calcula média de valor das tarefas pendentes
  // ============================================================
  final mediaPendentes = relatorio.mediaPendentes;
  if (pendentes.isEmpty) {
    print('Não existem tarefas pendentes para calcular média.');
  } else {
    print('Média de valor das tarefas pendentes: R\$ $mediaPendentes');
  }

  // ============================================================
  // RF10 - Calcula total de horas por status
  // ============================================================
  print('');
  print('Horas por status:');
  final horas = relatorio.horasPorStatus;
  horas.forEach((status, total) {
    print('$status: $total horas');
  });

  // ============================================================
  // RF11 - Identifica tarefas com dados incompletos
  // ============================================================
  print('');
  print('========== TAREFAS COM DADOS INCOMPLETOS ==========');
  final incompletas = relatorio.tarefasIncompletas;
  if (incompletas.isEmpty) {
    print('Nenhuma tarefa com dados incompletos.');
  } else {
    print('Tarefas com dados incompletos:');
    for (var item in incompletas) {
      List<String> problemas = [];
      if (item['titulo'] == null) problemas.add('título ausente');
      if (item['responsavel'] == null) problemas.add('responsável ausente');
      if (item['horas'] == null) problemas.add('horas ausentes');
      print('- ID ${item['id']}: ${problemas.join(', ')}');
    }
  }

  // ============================================================
  // RF12 - Exibe status únicos usando Set
  // ============================================================
  print('');
  print('Status encontrados:');
  for (var status in relatorio.statusUnicos) {
    print(status);
  }

  // ============================================================
  // RF15 - Relatório Final
  // ============================================================
  print('');
  print('========== RELATÓRIO FINAL DE TAREFAS ==========');
  print('');
  print('Total de tarefas analisadas: ${relatorio.quantidadeTotal}');
  print('Tarefas concluídas: ${concluidas.length}');
  print('Tarefas pendentes: ${pendentes.length}');
  print('Tarefas em andamento: ${emAndamento.length}');
  print('Tarefas canceladas: ${canceladas.length}');
  print('');
  print('Valor total das concluídas: R\$ ${relatorio.totalConcluidas}');
  print('Média de valor das pendentes: R\$ ${relatorio.mediaPendentes}');
  print('Total de horas concluídas: ${horas['concluida'] ?? 0}');
  print('');
  print('Status encontrados:');
  for (var status in relatorio.statusUnicos) {
    print(status);
  }
  print('');
  print('Tarefas com dados incompletos:');
  for (var item in incompletas) {
    final titulo = item['titulo'] ?? 'Sem título';
    print('ID ${item['id']} - $titulo');
  }
  print('');
  print('=================================================');
}