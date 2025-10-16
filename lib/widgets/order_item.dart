import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            tileColor: Colors.blueGrey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              '\$${widget.order.amount.toStringAsFixed(2)}',
              style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
              ),
            ),
            subtitle: Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(widget.order.dateTime),
              style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
              ),
            ),
            trailing: IconButton(
              icon: Icon(
          _expanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.blueAccent,
          size: 28,
              ),
              onPressed: () {
          setState(() {
            _expanded = !_expanded;
          });
              },
            ),
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 250),
            firstChild: SizedBox.shrink(),
            secondChild: Container(
              decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              constraints: BoxConstraints(
          maxHeight: min(widget.order.products.length * 48.0 + 10, 180),
              ),
              child: ListView.separated(
          itemCount: widget.order.products.length,
          itemBuilder: (ctx, i) {
            final prod = widget.order.products[i];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
            child: Text(
              prod.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
                ),
                SizedBox(width: 12),
                Text(
            '${prod.quantity}x \$${prod.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
                ),
              ],
            );
          },
          separatorBuilder: (ctx, i) => Divider(height: 18, color: Colors.grey[300]),
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
        ]
      ),
    );
  }
}
