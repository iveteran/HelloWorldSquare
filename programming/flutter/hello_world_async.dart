/*
void hello() async { 
  print('something exciting is going to happen here...'); 
}

void main() async {
  await hello();
  print('all done');
}
*/

Future delayedPrint(int seconds, String msg) {
  final duration = Duration(seconds: seconds);
  return Future.delayed(duration).then((value) => msg);
}

void main() async {
  print('Life');
  await delayedPrint(2, "Is").then((status){
    print(status);
  });
  print('Good');
}

// Refer: https://www.geeksforgeeks.org/using-await-async-in-dart/
//
// Run: dart run hello_world_async.dart
// Compile: dart compile exe hello_world_async.dart
