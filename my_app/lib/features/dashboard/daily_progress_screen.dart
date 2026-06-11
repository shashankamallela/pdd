import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DailyProgressScreen extends StatelessWidget {

  const DailyProgressScreen({super.key});

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
                    Color(0xFF00C853),
                    Color(0xFF64DD17),
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

                    "Daily Progress",

                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Your health performance today",

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

                  _progressCard(
                    "Healthy Meals",
                    "7 / 10",
                    0.7,
                    Colors.green,
                  ),

                  _progressCard(
                    "Water Intake",
                    "5 / 8",
                    0.6,
                    Colors.blue,
                  ),

                  _progressCard(
                    "Sugar Control",
                    "80%",
                    0.8,
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

  static Widget _progressCard(
    String title,
    String value,
    double progress,
    Color color,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 24),

      padding: const EdgeInsets.all(26),

      decoration: BoxDecoration(

        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.8),
            color,
          ],
        ),

        borderRadius: BorderRadius.circular(32),

      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Text(

                title,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(

                value,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(20),

            child: LinearProgressIndicator(

              value: progress,

              minHeight: 16,

              backgroundColor: Colors.white24,

              valueColor:
                  const AlwaysStoppedAnimation(
                Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}