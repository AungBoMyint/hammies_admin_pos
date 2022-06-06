import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Condition;
import 'package:responsive_framework/responsive_framework.dart';

class CustomMenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final Function onTap;

  CustomMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class DashboardMenu extends StatelessWidget {
  final List<CustomMenuItem> items;
  final double horizontalPadding;
  DashboardMenu({
    this.items = const [],
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    var itemWidth = (Get.width / 5) - horizontalPadding;
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: horizontalPadding,vertical: 20,),
      width: Get.width,
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: ResponsiveValue(context, defaultValue: 4,
                        valueWhen: [
                          Condition.smallerThan(
                            name: DESKTOP,
                            value: 3,
                          ),
                          Condition.smallerThan(
                            name: MOBILE,
                            value: 2,
                          )
                        ],
                        ).value ?? 0), 
        itemBuilder: (context,index){
          final item = items[index];
          return InkWell(
              onTap: () => item.onTap(),
              child: Container(
                padding: EdgeInsets.only(left: 0,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                        item.icon,
                        color: item.color,
                        size: ResponsiveValue(context, defaultValue: 90.0, 
                        valueWhen: [
                          Condition.smallerThan(
                            name: DESKTOP,
                            value: 35.0,
                          )
                        ],
                        ).value,
                      
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:ResponsiveValue(context, defaultValue: 18.0, 
                        valueWhen: [
                          Condition.smallerThan(
                            name: DESKTOP,
                            value: 16.0,
                          )
                        ],
                        ).value,
                          color: item.color,
                        ),
                      
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            );
        },
        ),
    );
  }
}
