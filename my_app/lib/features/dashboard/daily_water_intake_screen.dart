import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DailyWaterIntakeScreen extends StatefulWidget {

  const DailyWaterIntakeScreen({super.key});

  @override
  State<DailyWaterIntakeScreen> createState() =>
      _DailyWaterIntakeScreenState();
}

class _DailyWaterIntakeScreenState
    extends State<DailyWaterIntakeScreen> {

  int glasses = 5;

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
                    Color(0xFF00B4DB),
                    Color(0xFF0083B0),
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

                    "Water Intake",

                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Stay hydrated everyday",

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

                    width: double.infinity,

                    padding: const EdgeInsets.all(30),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan.shade300,
                          Colors.blue.shade500,
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(40),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.blue
                              .withOpacity(0.3),
                          blurRadius: 20,
                        ),

                      ],
                    ),

                    child: Column(

                      children: [

                        Container(

                          height: 220,
                          width: 220,

                          decoration: BoxDecoration(

                            shape: BoxShape.circle,

                            color: Colors.white
                                .withOpacity(0.2),
                          ),

                          child: Center(

                            child: Text(

                              "$glasses",

                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(

                          "Glasses Today",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            FloatingActionButton(

                              heroTag: "minus",

                              backgroundColor:
                                  Colors.red,

                              onPressed: () {

                                if (glasses > 0) {

                                  setState(() {

                                    glasses--;

                                  });
                                }
                              },

                              child: const Icon(
                                Icons.remove,
                              ),
                            ),

                            const SizedBox(width: 40),

                            FloatingActionButton(

                              heroTag: "plus",

                              backgroundColor:
                                  Colors.green,

                              onPressed: () {

                                setState(() {

                                  glasses++;

                                });

                              },

                              child: const Icon(
                                Icons.add,
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}