import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:mba/counter/counter_controller.dart';

// ignore: must_be_immutable
class CounterScreen extends StatelessWidget {
  CounterScreen({super.key});
  CounterController c = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Screen'),
      ),
      body: Center(
        child: Obx(() => Column(
              children: [
                Text(
                  'Counter: ${c.count}',
                  style: TextStyle(fontSize: 40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        c.increment();
                      },
                      child: Text('Inc'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        c.reset();
                      },
                      child: Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: c.count.value > 0
                          ? () {
                              c.decrement();
                            }
                          : null,
                      child: Text('Dec'),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
