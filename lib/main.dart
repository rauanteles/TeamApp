import 'package:flutter/material.dart';
import 'package:groupapp/components/pessoa_list.dart';

main() => runApp(const GroupApp());

class GroupApp extends StatelessWidget {
  const GroupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const PessoaList();
  }
}