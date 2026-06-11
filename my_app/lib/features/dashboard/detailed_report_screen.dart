import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailedReportScreen extends StatelessWidget {

  const DetailedReportScreen({super.key});

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
                    Color(0xFF8E2DE2),
                    Color(0xFF4A00E0),
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

                    "Detailed Report",

                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "AI generated oral health analysis",

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

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.all(30),

                    decoration: BoxDecoration(

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6A11CB),
                          Color(0xFF2575FC),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(34),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.deepPurple
                              .withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),

                      ],
                    ),

                    child: const Column(

                      children: [

                        Text(

                          "AI Health Score",

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),

                        SizedBox(height: 18),

                        Text(

                          "82%",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(

                          "Moderate Risk",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(

                    "Nutrition Analysis",

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _reportTile(
                    "Sugar Level",
                    "High",
                    Colors.red,
                    Icons.cake_outlined,
                  ),

                  _reportTile(
                    "Acidity",
                    "Medium",
                    Colors.orange,
                    Icons.warning_amber_rounded,
                  ),

                  _reportTile(
                    "Dental Risk",
                    "Low",
                    Colors.green,
                    Icons.health_and_safety_outlined,
                  ),

                  _reportTile(
                    "Hydration",
                    "Good",
                    Colors.blue,
                    Icons.water_drop_outlined,
                  ),

                  const SizedBox(height: 40),

                  Container(

                    width: double.infinity,

                    padding: const EdgeInsets.all(26),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(30),

                      boxShadow: [

                        BoxShadow(
                          color:
                              Colors.black.withOpacity(
                            0.05,
                          ),
                          blurRadius: 12,
                        ),

                      ],
                    ),

                    child: const Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Row(

                          children: [

                            Icon(
                              Icons.tips_and_updates,
                              color: Colors.amber,
                              size: 32,
                            ),

                            SizedBox(width: 12),

                            Text(

                              "AI Recommendation",

                              style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 20),

                        Text(

                          "Reduce sugary drinks and increase water intake. Include more calcium-rich foods and brush your teeth after meals.",

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            height: 1.8,
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(

                    width: double.infinity,

                    height: 65,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.deepPurple,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),

                      onPressed: () {

                        context.go('/dashboard');

                      },

                      child: const Text(

                        "Back To Dashboard",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  static Widget _reportTile(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(30),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),

        ],
      ),

      child: Row(

        children: [

          Container(

            height: 65,
            width: 65,

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(

            child: Text(

              title,

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Text(

              value,

              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

        ],
      ),
    );
  }
}