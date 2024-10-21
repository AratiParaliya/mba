import 'package:get/get.dart';
//show GetxController, IntExtension;

class CounterController extends GetxController {
  var count = 0.obs;
  increment() {
    count++;
  }

  decrement() {
    if (count.value > 0) count--;
  }
  // Method to reset the count to 0

  reset() {
    count.value = 0;
  }
}
