import 'package:get/get.dart';


class CounterController extends GetxController {
  var count = 0.obs;
  increment() {
    count++;
  }

  decrement() {
    if (count.value > 0) count--;
  }

  reset() {
    count.value = 0;
  }
}
