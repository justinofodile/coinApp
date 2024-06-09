// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:coin_app/pages/detail_page.dart';
import 'package:coin_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  // ignore: prefer_final_fields
  String? _selectedCoin = 'bitcoin';
  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _selectedCoinDropDown(),
                _dataWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = [
      'bitcoin',
      'ethereum',
      'tether',
      'cardano',
      'ripple',
      'bitcix',
      'pine',
      'pi-network-iou',
      'crowdswap'
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      hint: const Text('Select a Coin'),
      value: _selectedCoin,
      items: _items,
      onChanged: (_value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: const Color.fromRGBO(
        83,
        88,
        206,
        1.0,
      ),
      iconSize: 40,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidget() {
    return FutureBuilder(
      future: _http!.get("/coins/$_selectedCoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(_snapshot.data.toString());
          num _usdPrice = _data['market_data']['current_price']['usd'];
          num _change24h = _data['market_data']['price_change_percentage_24h'];
          Map _exchangeRate = _data['market_data']['current_price'];
          // print(_exchangeRate);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Double Tap on Logo to Go to Exchange Rate",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext _context) {
                      return DetailPage(
                          rates: _exchangeRate, coinName: _selectedCoin);
                    }),
                  );
                },
                child: _coinImageWidget(
                  _data['image']['large'],
                ),
              ),
              _currentPriceWidget(_usdPrice),
              _percentageChangeWidget(_change24h),
              _descriptionCardWidget(_data['description']['en']),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "$_change %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImageWidget(String _imageUrl) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(
          _imageUrl,
        ),
      )),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: const Color.fromRGBO(88, 60, 197, 1.0),
      child: Text(
        _description,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
