import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiskAnalysisScreen extends StatelessWidget {

  final Map<String, dynamic> foodData;

  const RiskAnalysisScreen({

    super.key,

    required this.foodData,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            children: [

              Container(

                padding: const EdgeInsets.all(24),

                decoration: const BoxDecoration(

                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF1D4ED8),
                    ],
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        IconButton(

                          onPressed: () {

                            context.pop();

                          },

                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),

                        IconButton(

                          onPressed: () {

                            showDialog(

                              context: context,

                              builder: (context) {

                                return AlertDialog(

                                  title: const Text(
                                    "About Analysis",
                                  ),

                                  content: const Text(

                                    "This AI-powered analysis predicts oral health risks based on sugar level, acidity, ingredients, and nutritional impact of the food.",

                                  ),

                                  actions: [

                                    TextButton(

                                      onPressed: () {

                                        Navigator.pop(
                                          context,
                                        );

                                      },

                                      child: const Text(
                                        "OK",
                                      ),
                                    ),

                                  ],
                                );
                              },
                            );
                          },

                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(

                      "Risk Analysis",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(

                      foodData['food'],

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 30),

                  ],
                ),
              ),

              Padding(

                padding: const EdgeInsets.all(24),

                child: Column(

                  children: [

                    /// ABOUT ANALYSIS
                    Container(

                      width: double.infinity,

                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(

                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),

                      child: const Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              Icon(
                                Icons.analytics_outlined,
                                color: Colors.white,
                                size: 32,
                              ),

                              SizedBox(width: 12),

                              Text(

                                "About Analysis",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 20),

                          Text(

                            "This AI system predicts oral health risks using food ingredients, sugar levels, acidity, and nutrition patterns.",

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                              height: 1.7,
                            ),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// RISK SCORE
                    Container(

                      width: double.infinity,

                      padding: const EdgeInsets.all(30),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 10,
                          ),

                        ],
                      ),

                      child: Column(

                        children: [

                          Container(

                            height: 160,
                            width: 160,

                            decoration: BoxDecoration(

                              shape: BoxShape.circle,

                              color: Colors.orange
                                  .withOpacity(0.12),
                            ),

                            child: Center(

                              child: Text(

                                foodData['score']
                                    .toString(),

                                style: const TextStyle(
                                  fontSize: 90,
                                  color:
                                      Colors.orange,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(

                            "${foodData['risk']} Risk",

                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(

                            "High sugar and acidic content detected. Moderate oral health risk identified.",

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              height: 1.6,
                            ),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// QUICK INSIGHTS
                    Row(

                      children: [

                        Expanded(

                          child: _insightCard(
                            "Sugar",
                            foodData['sugar'],
                            Colors.red,
                            Icons.cake_outlined,
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(

                          child: _insightCard(
                            "Acidity",
                            foodData['acidity'],
                            Colors.orange,
                            Icons.warning_amber,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 40),

                    /// VIEW REPORT BUTTON
                    SizedBox(

                      width: double.infinity,
                      height: 65,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          backgroundColor:
                              const Color(
                            0xFF2563EB,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              22,
                            ),
                          ),
                        ),

                        onPressed: () {

                          context.push(
                            '/detailed-report',
                          );

                        },

                        child: const Text(

                          "View Detailed Report",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BACK TO DASHBOARD
                    SizedBox(

                      width: double.infinity,
                      height: 65,

                      child: OutlinedButton(

                        style:
                            OutlinedButton.styleFrom(

                          side: const BorderSide(
                            color:
                                Color(0xFF2563EB),
                            width: 2,
                          ),

                          shape:
                              RoundedRectangleBorder(
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
                            color:
                                Color(0xFF2563EB),
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
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
      ),
    );
  }

  static Widget _insightCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),

        ],
      ),

      child: Column(

        children: [

          Container(

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),

          const SizedBox(height: 18),

          Text(

            title,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}