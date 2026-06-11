import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';

class TypeFoodScreen extends StatefulWidget {

  const TypeFoodScreen({super.key});

  @override
  State<TypeFoodScreen> createState() =>
      _TypeFoodScreenState();
}

class _TypeFoodScreenState
    extends State<TypeFoodScreen> {

  final TextEditingController foodController =
      TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F7FB),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        leading: IconButton(

          icon: const Icon(Icons.arrow_back),

          onPressed: () {

            context.pop();

          },
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              "Type Food",

              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(

              "Enter your food manually",

              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 40),

            Container(

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(30),
              ),

              child: TextField(

                controller: foodController,

                maxLines: 5,

                decoration: InputDecoration(

                  hintText:
                      "Example:\nBurger, Coke, French Fries",

                  border: InputBorder.none,

                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(

              width: double.infinity,
              height: 65,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.blue,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(24),
                  ),
                ),

                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    final result =
                        await ApiService
                            .predictFood(

                      foodController.text,

                    );

                    if (!context.mounted) return;

                    context.push(

                      '/food-detected',

                      extra: result,
                    );
                  } catch (error) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString().replaceFirst('Exception: ', ''),
                        ),
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },

                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(

                        "Analyze Food",

                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
