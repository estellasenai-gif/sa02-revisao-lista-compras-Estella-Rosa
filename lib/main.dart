import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// =====================================================
// CORES DO APLICATIVO
// =====================================================

const Color rosaPrincipal = Color(0xFFE91E63);
const Color rosaEscuro = Color(0xFFC2185B);
const Color rosaClaro = Color(0xFFFCE4EC);
const Color rosaMuitoClaro = Color(0xFFFFF5F8);
const Color textoEscuro = Color(0xFF30242A);
const Color textoCinza = Color(0xFF7D7076);

// =====================================================
// APP PRINCIPAL
// =====================================================

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: rosaPrincipal,
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: rosaMuitoClaro,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: textoEscuro,
          elevation: 0,
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color(0xFFF3DDE5),
            ),
          ),
        ),
      ),

      home: const ListaComprasScreen(),
    );
  }
}

// =====================================================
// MODELO ITEM
// =====================================================

class Item {
  final String id;
  String nome;
  String quantidade;
  bool comprado;

  Item({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

// =====================================================
// TELA PRINCIPAL
// =====================================================

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() =>
      _ListaComprasScreenState();
}

class _ListaComprasScreenState
    extends State<ListaComprasScreen> {

  final List<Item> _itens = [
    Item(
      id: '1',
      nome: 'Arroz',
      quantidade: '2 pacotes',
    ),
    Item(
      id: '2',
      nome: 'Leite',
      quantidade: '3 caixas',
      comprado: true,
    ),
    Item(
      id: '3',
      nome: 'Ovos',
      quantidade: '1 dúzia',
    ),
    Item(
      id: '4',
      nome: 'Café',
      quantidade: '1 pacote',
    ),
  ];

  // =====================================================
  // ABRIR CADASTRO
  // =====================================================

  Future<void> _abrirCadastro() async {
    final novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroItemScreen(),
      ),
    );

    if (novoItem != null) {
      setState(() {
        _itens.add(novoItem);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: rosaEscuro,
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${novoItem.nome} foi adicionado à lista!',
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    }
  }

  // =====================================================
  // ALTERAR STATUS
  // =====================================================

  void _alternarComprado(String id) {
    setState(() {
      final item = _itens.firstWhere(
        (item) => item.id == id,
      );

      item.comprado = !item.comprado;
    });
  }

  // =====================================================
  // REMOVER ITEM
  // =====================================================

  void _removerItem(String id) {
    final index = _itens.indexWhere(
      (item) => item.id == id,
    );

    if (index == -1) return;

    final itemRemovido = _itens[index];

    setState(() {
      _itens.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF5C4B52),
        content: Text(
          '${itemRemovido.nome} foi removido da lista.',
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final quantidadeComprados =
        _itens.where((item) => item.comprado).length;

    final quantidadeTotal = _itens.length;

    final progresso = quantidadeTotal == 0
        ? 0.0
        : quantidadeComprados / quantidadeTotal;

    return Scaffold(

      // =================================================
      // APPBAR
      // =================================================

      appBar: AppBar(
        toolbarHeight: 78,

        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: rosaClaro,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: rosaPrincipal,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lista de Compras',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: textoEscuro,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Organize tudo com carinho 💗',
                  style: TextStyle(
                    fontSize: 11,
                    color: textoCinza,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16,
              top: 20,
              bottom: 20,
            ),

            padding: const EdgeInsets.symmetric(
              horizontal: 13,
            ),

            decoration: BoxDecoration(
              color: rosaClaro,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Center(
              child: Text(
                '$quantidadeComprados/$quantidadeTotal',
                style: const TextStyle(
                  color: rosaEscuro,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),

      // =================================================
      // BODY
      // =================================================

      body: Column(
        children: [

          // =================================================
          // RESUMO
          // =================================================

          Container(
            width: double.infinity,

            margin: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              18,
            ),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  rosaPrincipal,
                  rosaEscuro,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: rosaPrincipal.withOpacity(0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),

            child: Column(
              children: [

                Row(
                  children: [

                    Container(
                      width: 48,
                      height: 48,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: const Icon(
                        Icons.shopping_basket_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Progresso das compras',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            quantidadeTotal == 0
                                ? 'Nenhum item na lista'
                                : '$quantidadeComprados de '
                                  '$quantidadeTotal itens comprados',

                            style: const TextStyle(
                              color: Color(0xFFFFEAF2),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '${(progresso * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 8,
                    backgroundColor:
                        Colors.white.withOpacity(0.20),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =================================================
          // LISTA
          // =================================================

          Expanded(
            child: _itens.isEmpty
                ? _listaVazia()
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: 100,
                    ),

                    itemCount: _itens.length,

                    itemBuilder: (context, index) {
                      final item = _itens[index];

                      return Card(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),

                          leading: Container(
                            width: 43,
                            height: 43,

                            decoration: BoxDecoration(
                              color: item.comprado
                                  ? const Color(0xFFF1F1F1)
                                  : rosaClaro,
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),

                            child: Checkbox(
                              value: item.comprado,

                              activeColor: rosaPrincipal,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5),
                              ),

                              onChanged: (_) {
                                _alternarComprado(
                                  item.id,
                                );
                              },
                            ),
                          ),

                          title: Text(
                            item.nome,

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,

                              decoration: item.comprado
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,

                              color: item.comprado
                                  ? const Color(0xFFAAA2A6)
                                  : textoEscuro,
                            ),
                          ),

                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 5,
                            ),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 14,
                                  color: rosaPrincipal,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  item.quantidade,

                                  style: TextStyle(
                                    fontSize: 12,
                                    color: item.comprado
                                        ? const Color(
                                            0xFFAAA2A6,
                                          )
                                        : textoCinza,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          trailing: IconButton(
                            tooltip: 'Remover',

                            icon: const Icon(
                              Icons.delete_outline_rounded,
                            ),

                            color: const Color(0xFFD65C78),

                            onPressed: () {
                              _removerItem(item.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // =================================================
      // BOTÃO ADICIONAR
      // =================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _abrirCadastro,

        backgroundColor: rosaPrincipal,

        foregroundColor: Colors.white,

        elevation: 5,

        icon: const Icon(
          Icons.add_rounded,
        ),

        label: const Text(
          'Adicionar item',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // LISTA VAZIA
  // =====================================================

  Widget _listaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: rosaClaro,
                borderRadius:
                    BorderRadius.circular(28),
              ),

              child: const Icon(
                Icons.shopping_cart_rounded,
                size: 42,
                color: rosaPrincipal,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Sua lista está vazia',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: textoEscuro,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Adicione produtos para começar\n'
              'sua lista de compras 💗',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: textoCinza,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: rosaMuitoClaro,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: rosaClaro,
                ),
              ),

              child: const Text(
                'Comece adicionando um produto ✨',
                style: TextStyle(
                  color: rosaEscuro,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// TELA DE CADASTRO
// =====================================================

class CadastroItemScreen extends StatefulWidget {
  const CadastroItemScreen({super.key});

  @override
  State<CadastroItemScreen> createState() =>
      _CadastroItemScreenState();
}

class _CadastroItemScreenState
    extends State<CadastroItemScreen> {

  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController _quantidadeController =
      TextEditingController();

  // =====================================================
  // SALVAR
  // =====================================================

  void _salvarItem() {
    final nome = _nomeController.text.trim();

    final quantidade =
        _quantidadeController.text.trim();

    if (nome.isEmpty || quantidade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: rosaEscuro,

          content: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),

              SizedBox(width: 10),

              Text(
                'Preencha todos os campos.',
              ),
            ],
          ),

          behavior: SnackBarBehavior.floating,

          margin: const EdgeInsets.all(16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

      return;
    }

    final novoItem = Item(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      nome: nome,

      quantidade: quantidade,
    );

    Navigator.pop(
      context,
      novoItem,
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rosaMuitoClaro,

      appBar: AppBar(
        title: const Text(
          'Adicionar item',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          32,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            // =================================================
            // CABEÇALHO
            // =================================================

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    rosaClaro,
                    Color(0xFFFFF0F5),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(22),

                border: Border.all(
                  color: const Color(0xFFF5C9D9),
                ),
              ),

              child: Row(
                children: [

                  Container(
                    width: 55,
                    height: 55,

                    decoration: BoxDecoration(
                      color: rosaPrincipal,
                      borderRadius:
                          BorderRadius.circular(17),

                      boxShadow: [
                        BoxShadow(
                          color:
                              rosaPrincipal.withOpacity(0.20),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Novo produto 💗',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: textoEscuro,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Adicione um produto à sua lista.',
                          style: TextStyle(
                            fontSize: 12,
                            color: textoCinza,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =================================================
            // PRODUTO
            // =================================================

            const Text(
              'Produto',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textoEscuro,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _nomeController,

              textCapitalization:
                  TextCapitalization.sentences,

              decoration: InputDecoration(
                hintText: 'Ex.: Arroz',

                prefixIcon: const Icon(
                  Icons.shopping_basket_outlined,
                  color: rosaPrincipal,
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: const BorderSide(
                    color: Color(0xFFF0DDE4),
                  ),
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: const BorderSide(
                    color: Color(0xFFF0DDE4),
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: const BorderSide(
                    color: rosaPrincipal,
                    width: 1.8,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // QUANTIDADE
            // =================================================

            const Text(
              'Quantidade',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textoEscuro,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  _quantidadeController,

              decoration: InputDecoration(
                hintText: 'Ex.: 2 pacotes',

                prefixIcon: const Icon(
                  Icons.inventory_2_outlined,
                  color: rosaPrincipal,
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: const BorderSide(
                    color: Color(0xFFF0DDE4),
                  ),
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: const BorderSide(
                    color: Color(0xFFF0DDE4),
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide: const BorderSide(
                    color: rosaPrincipal,
                    width: 1.8,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // =================================================
            // SALVAR
            // =================================================

            SizedBox(
              height: 55,

              child: ElevatedButton.icon(
                onPressed: _salvarItem,

                icon: const Icon(
                  Icons.check_circle_rounded,
                ),

                label: const Text(
                  'Salvar item',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: rosaPrincipal,

                  foregroundColor: Colors.white,

                  elevation: 4,

                  shadowColor:
                      rosaPrincipal.withOpacity(0.25),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();

    super.dispose();
  }
}