import 'package:flutter/material.dart';
import 'package:http/http.dart' as minha;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _resultado = 'Resultado';
  final TextEditingController _cepSelecionado = TextEditingController();

  _recuperarCep() async {
    if (_formKey.currentState!.validate()) {
      String url = 'https://viacep.com.br/ws/${_cepSelecionado.text}/json/';

      minha.Response response = await minha.get(Uri.parse(url));
      Map<String, dynamic> retorno = json.decode(response.body);

      if (retorno.containsKey('erro')) {
        setState(() {
          _resultado = 'CEP não encontrado';
        });
        return;
      }

      String cep = retorno['cep'] ?? 'Não informado';
      String logradouro = retorno['logradouro'] ?? 'Não informado';
      String complemento = retorno['complemento'] ?? 'Não informado';
      String bairro = retorno['bairro'] ?? 'Não informado';
      String localidade = retorno['localidade'] ?? 'Não informado';
      String uf = retorno['uf'] ?? 'Não informado';
      String ddd = retorno['ddd'] ?? 'Não informado';

      setState(() {
        _resultado =
            'CEP: $cep\nLogradouro: $logradouro\nComplemento: $complemento\nBairro: $bairro\nLocalidade: $localidade\nUF: $uf\nDDD: $ddd';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Consumo de Serviços Web'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Digite um Cep abaixo e clique no botão para ver seus dados:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo CEP é obrigatório!';
                    } else if (value.length != 8 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'O CEP deve conter exatamente 8 dígitos numéricos!';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  controller: _cepSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Digite um CEP. Ex: 12345678',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _recuperarCep,
                  child: const Text('Clique Aqui'),
                ),
                const SizedBox(height: 30),
                Text(
                  _resultado,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
