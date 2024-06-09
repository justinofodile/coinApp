// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:ffi';

import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map rates;
  final String? coinName;
  const DetailPage({super.key, required this.rates, required this.coinName});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exchange Rate ($coinName)",
          style: const TextStyle(
            color: Colors.white60,
          ),
        ),
        backgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (
              _context,
              _index,
            ) {
              String _currency = _currencies[_index].toString().toUpperCase();
              String _exchangeRate =
                  _exchangeRates[_index].toString().toUpperCase();
              return ListTile(
                title: Text(
                  "$_currency: $_exchangeRate",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
