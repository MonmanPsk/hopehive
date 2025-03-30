import 'package:flutter/material.dart';
import 'package:hopehive/core/models/request.dart';

class RequestPage extends StatelessWidget {
  final Request request;

  const RequestPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
