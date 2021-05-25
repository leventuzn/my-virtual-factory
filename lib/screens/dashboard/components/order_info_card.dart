import 'package:flutter/material.dart';
import '../../../constants.dart';

class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({
    Key key,
    @required this.status,
    @required this.icon,
    @required this.numOfOrders,
  }) : super(key: key);

  final String status;
  final Icon icon;
  final int numOfOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: icon,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Text(numOfOrders.toString())
        ],
      ),
    );
  }
}
