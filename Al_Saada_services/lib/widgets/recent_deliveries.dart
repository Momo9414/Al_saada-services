import 'package:flutter/material.dart';

class RecentDeliveries extends StatelessWidget {
  const RecentDeliveries({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Livraisons récentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.history),
              ],
            ),
            SizedBox(height: 16),
            DeliveryItem(
              id: '001',
              from: 'Cocody',
              to: 'Marcory',
              status: 'En cours',
            ),
            Divider(),
            DeliveryItem(
              id: '002',
              from: 'Yopougon',
              to: 'Plateau',
              status: 'En cours',
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryItem extends StatelessWidget {
  final String id;
  final String from;
  final String to;
  final String status;

  const DeliveryItem({
    super.key,
    required this.id,
    required this.from,
    required this.to,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Livraison #$id',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '$from → $to',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}