import 'package:flutter/material.dart';

class CommandeScreen extends StatelessWidget {
  const CommandeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes Commandes'),
          bottom: const TabBar(
            labelColor: Color(0xFFF97316),
            unselectedLabelColor: Color(0xFF4B5563),
            tabs: [
              Tab(text: 'En cours'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet des commandes en cours
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 2,
              itemBuilder: (context, index) {
                return OrderCard(
                  orderNumber: '00${index + 1}',
                  from: index == 0 ? 'Cocody' : 'Yopougon',
                  to: index == 0 ? 'Marcory' : 'Plateau',
                  date: '28/12/2024',
                  price: index == 0 ? '1500' : '2000',
                  status: 'En cours',
                );
              },
            ),
            // Onglet historique
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return OrderCard(
                  orderNumber: '00${index + 1}',
                  from: 'Cocody',
                  to: 'Marcory',
                  date: '27/12/2024',
                  price: '1500',
                  status: 'Terminé',
                  isCompleted: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String from;
  final String to;
  final String date;
  final String price;
  final String status;
  final bool isCompleted;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.from,
    required this.to,
    required this.date,
    required this.price,
    required this.status,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Livraison #$orderNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$price FCFA',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$from → $to',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: $date',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Suivre'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}