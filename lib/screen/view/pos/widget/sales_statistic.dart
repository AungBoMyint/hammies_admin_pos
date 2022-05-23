import 'package:flutter/material.dart';

import '../../../../utils/theme.dart';


class SalesStatistic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: theme.warning,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Sale(s) Total",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Card(
              color: theme.success,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Sale(s) Count",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
