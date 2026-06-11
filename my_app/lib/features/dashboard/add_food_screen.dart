import 'package:flutter/material.dart';

class AddFoodScreen extends StatelessWidget {

  const AddFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Food"),
      ),

      body: const Center(

        child: Text(
          "Add Food Screen",
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}