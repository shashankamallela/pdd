import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatelessWidget {

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7FB),

      body: SingleChildScrollView(

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),

              decoration: const BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF7A18),
                    Color(0xFFFFB800),
                  ],
                ),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  GestureDetector(

                    onTap: () {

                      context.pop();

                    },

                    child: Container(

                      height: 52,
                      width: 52,

                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(

                    "Food History",

                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(

                    "Track all your previous scans",

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
            ),

            Padding(

              padding: const EdgeInsets.all(24),

              child: Column(

                children: [

                  Container(

                    padding: const EdgeInsets.all(28),

                    decoration: BoxDecoration(

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF9966),
                          Color(0xFFFF5E62),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(32),
                    ),

                    child: const Column(

                      children: [

                        Text(

                          "This Week",

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 16),

                        Text(

                          "14 Foods Scanned",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  _historyCard(
                    "🍔",
                    "Burger + Coke",
                    "High Sugar Risk",
                    "Today",
                    Colors.red,
                  ),

                  _historyCard(
                    "🥗",
                    "Healthy Salad",
                    "Low Risk",
                    "Yesterday",
                    Colors.green,
                  ),

                  _historyCard(
                    "🍕",
                    "Cheese Pizza",
                    "Medium Risk",
                    "2 Days Ago",
                    Colors.orange,
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  static Widget _historyCard(
    String emoji,
    String title,
    String risk,
    String date,
    Color color,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 22),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(30),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
          ),

        ],
      ),

      child: Row(

        children: [

          Container(

            height: 90,
            width: 90,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(24),
            ),

            child: Text(
              emoji,
              style: const TextStyle(fontSize: 42),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: Text(

                    risk,

                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),

          Text(

            date,

            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

        ],
      ),
    );
  }
}