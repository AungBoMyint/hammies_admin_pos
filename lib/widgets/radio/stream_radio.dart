import 'package:flutter/material.dart';

import '../../model/pos/expend_category.dart';
import '../../utils/theme.dart';
import '../pos/input/input.dart';

class ExStreamRadio extends StatefulWidget {
  final String id;
  final String label;
  final String value;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool wrapped;

  //---
  final String valueField;
  final String labelField;
  final List<ExpendCategory> categoryList;

  const ExStreamRadio({
    Key? key,
    required this.id,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.keyboardType,
    this.wrapped = false,
    required this.labelField,
    required this.valueField,
    required this.categoryList,
  }) : super(key: key);

  @override
  _ExStreamRadioState createState() => _ExStreamRadioState();
}

class _ExStreamRadioState extends State<ExStreamRadio> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.valueField;
  }

  @override
  Widget build(BuildContext context) {
    return widget.categoryList.isNotEmpty
        ? Container(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: 80.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: Text(widget.label),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.categoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var item = widget.categoryList[index];

                        bool selected = selectedValue == item.category;

                        return InkWell(
                          onTap: () {
                            if (selectedValue == item) {
                              selectedValue = null;
                              setState(() {});
                              Input.set(widget.id, selectedValue);
                              widget.onChanged(selectedValue!);
                              return;
                            }
                            selectedValue = item.category;
                            setState(() {});

                            Input.set(widget.id, selectedValue);
                            widget.onChanged(selectedValue!);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            margin: EdgeInsets.only(right: 10.0),
                            height: theme.mediumHeight,
                            decoration: BoxDecoration(
                              borderRadius: theme.largeRadius,
                              color: selected
                                  ? theme.primary
                                  : theme.inactiveColor,
                            ),
                            child: Center(
                                child: Text(
                              item.category,
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color:
                                    selected ? Colors.white : theme.textColor,
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox(height: 0, width: 0);
  }
}
