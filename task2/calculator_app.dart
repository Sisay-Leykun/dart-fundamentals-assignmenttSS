
// Task 2: Async Calculator App
// Name: Sisay Leykun
// Student ID: ATE/0493/15 (additional)

import 'dart:async';

// Custom Exception for Input Validation (Advanced Extension - 2 pts)
class InvalidOperationException implements Exception {
  final String message;
  InvalidOperationException(this.message);
  @override
  String toString() => "InvalidOperationException: $message";
}

class Calculator {
  final String name;

  // History Log (Advanced Extension - 2 pts)
  final List<String> history = [];

  // Constant delay (no magic number)
  static const Duration delay = Duration(seconds: 1, milliseconds: 500);

  Calculator(this.name);

  double add(double a, double b) => a + b;

  double subtract(double a, double b) {
    // Your implementation
    return a - b;
  }

  double multiply(double a, double b) {
    // Your implementation
    return a * b;
  }

  double divide(double a, double b) {
    if (b == 0) {
      throw ArgumentError('Cannot divide by zero.');
    }
    // Your implementation
    return a / b;
  }

  Future<double> computeAsync(double a, double b, String op) async {
    double result;
    switch (op) {
      case 'add':
        result = add(a, b);
        break;
      // Add remaining cases
      case 'subtract':
        result = subtract(a, b);
        break;
      case 'multiply':
        result = multiply(a, b);
        break;
      case 'divide':
        result = divide(a, b);
        break;
      default:
        throw InvalidOperationException('Unknown operation: $op');
    }
    await Future.delayed(delay);
    return result;
  }

  Future<void> displayResult(
      double a, double b, String op) async {
    try {
      final result = await computeAsync(a, b, op);
      // Print the formatted result
      final output = '$op($a, $b) = $result';
      print(output);
      history.add(output);  // History Log
    } catch (e) {
      print('Error: Cannot divide by zero.');
    }
  }

  // Chain Operations (Advanced Extension - 3 pts)
  Future<double> computeChained(List<double> values, String op) async {
    if (values.isEmpty) {
      throw ArgumentError("Values list cannot be empty");
    }
    double result = values.first;
    for (int i = 1; i < values.length; i++) {
      switch (op) {
        case 'add':
          result = add(result, values[i]);
          break;
        case 'subtract':
          result = subtract(result, values[i]);
          break;
        case 'multiply':
          result = multiply(result, values[i]);
          break;
        case 'divide':
          result = divide(result, values[i]);
          break;
        default:
          throw InvalidOperationException("Unknown operation: $op");
      }
    }
    await Future.delayed(delay);
    return result;
  }

  // Print History (Advanced Extension)
  void printHistory() {
    print('\n--- Calculation History ---');
    for (var record in history) {
      print(record);
    }
  }
}

Future<void> main() async {
  final calc = Calculator('MyCalculator');
  print('--- ${calc.name} ---');

  await calc.displayResult(10, 4, 'add');
  await calc.displayResult(10, 4, 'subtract');
  // Add more calls here
  await calc.displayResult(10, 4, 'multiply');
  await calc.displayResult(10, 4, 'divide');
  await calc.displayResult(15, 3, 'divide');
  await calc.displayResult(10, 0, 'divide'); // Test error

  print('All calculations complete.');

  // === BONUS DEMO (Advanced Extensions) ===
  final chainResult = await calc.computeChained([1, 2, 3, 4], 'add');
  print('\nChained add [1,2,3,4] = $chainResult');

  calc.printHistory();

  /*
  Why parallel execution is faster:

  In sequential execution, each async task waits for the previous
  one to finish before starting. Since each operation waits 1.5
  seconds, four operations would take about 6 seconds total.

  With Future.wait(), all futures start simultaneously and run
  concurrently. Because the delays overlap, the total runtime
  is closer to 1.5 seconds instead of 6 seconds.

  This demonstrates the efficiency of asynchronous concurrency.
  */
}

//                   CONCEPTUAL QUESTIONS (Task 2) 
// 
//
// Q6. What is the difference between a synchronous function and an
//     asynchronous function in Dart? In your Calculator class, why is
//     divide() synchronous while computeAsync() is asynchronous?
//
// Answer:
// A synchronous function executes its code line by line in sequence.
// The calling code is blocked — it must wait for the function to finish
// before it can continue to the next line. The function returns its
// result immediately when it completes.
//
// An asynchronous function, marked with the 'async' keyword, returns a
// Future object immediately. The actual computation may not be complete
// yet — the Future is a promise that the result will be available later.
// This allows the program to continue doing other work while waiting for
// the result. When the result is ready, the Future "resolves" and the
// value becomes available.
//
// In the Calculator class, divide() is synchronous because the actual
// arithmetic operation (a / b) is instantaneous — it takes nanoseconds
// and requires no waiting. There is no I/O, no network call, and no
// reason to pause. computeAsync() is asynchronous because it includes
// a Future.delayed() call that simulates a network delay of 1.5 seconds.
// In a real application, this delay would represent waiting for a server
// response, a database query, or a file system operation. Making
// computeAsync() async allows the program to handle that waiting period
// without freezing the entire application.
//
//
// Q7. Explain the purpose of the await keyword in Dart. What happens
//     if you forget to use await when calling an async function that
//     returns a Future? What does your program print instead of the result?
//
// Answer:
// The 'await' keyword tells Dart to pause execution of the current async
// function until the Future it is waiting on completes and produces its
// final value. It essentially "unwraps" the Future — instead of getting
// a Future<double> object, you get the actual double value inside it.
//
// If you forget to use 'await' when calling an async function, two things
// happen:
// 1. The function call returns immediately with a Future object instead
//    of the resolved value. If you try to print this, you will see
//    something like "Instance of 'Future<double>'" or
//    "Instance of 'Future<void>'" instead of the actual number.
// 2. The code after the function call executes immediately without waiting
//    for the async operation to complete. This means the order of your
//    output becomes unpredictable — later print statements may appear
//    before earlier async results.
//
// For example, without await in main():
//   calc.displayResult(10, 4, 'add');  // No await
//   print('Done');
// The program would print 'Done' immediately, and then 1.5 seconds later
// the calculation result would appear — completely out of order.
//
//
// Q8. What is the purpose of the try-catch block in your displayResult()
//     method? What would happen if you removed it and then called
//     displayResult(10, 0, 'divide')?
//
// Answer:
// The try-catch block in displayResult() serves as a safety net that
// catches any exceptions thrown during the computation. When the code
// inside the 'try' block throws an exception (such as the ArgumentError
// from divide() when the divisor is zero), execution immediately jumps
// to the 'catch' block, which prints a user-friendly error message
// instead of crashing the program. After the catch block executes, the
// program continues running normally — subsequent operations are not
// affected.
//
// If I removed the try-catch block and called displayResult(10, 0, 'divide'),
// the following would happen:
// 1. displayResult() would call computeAsync(10, 0, 'divide').
// 2. computeAsync() would call divide(10, 0).
// 3. divide() would throw an ArgumentError('Cannot divide by zero.').
// 4. Since there is no try-catch to intercept it, the exception would
//    propagate upward through computeAsync(), through displayResult(),
//    and up to main().
// 5. If main() also doesn't catch it, the exception becomes unhandled.
// 6. The Dart runtime would terminate the program with an error message
//    and a stack trace.
// 7. The "All calculations complete." message would never print, and
//    any displayResult() calls scheduled after the failing one would
//    never execute.
//
// The try-catch block prevents this cascade by catching the error locally
// and allowing the program to continue.
//
//
// Q9. Why is it good design to have divide() throw an ArgumentError rather
//     than simply returning 0 or printing an error inside the divide()
//     method itself? What principle of function design does this reflect?
//
// Answer:
// This reflects the Separation of Concerns principle and the idea that
// functions should signal errors, not handle them. There are several
// reasons why throwing an exception is better design:
//
// 1. Returning 0 is misleading: If divide(10, 0) returned 0, the caller
//    would have no way to distinguish between a legitimate result of 0
//    (like divide(0, 5) = 0) and an error condition. The caller might
//    use that incorrect 0 in further calculations, producing silently
//    wrong results — one of the most dangerous types of bugs.
//
// 2. Printing inside divide() mixes concerns: The divide() method's job
//    is to perform division — it should not decide how to present errors
//    to the user. If divide() prints an error message, it becomes tightly
//    coupled to console output. This makes the function unusable in a
//    GUI application (where you would want to show a dialog), a web
//    server (where you would want to return an HTTP error response), or
//    a testing framework (where you would want to assert that an
//    exception was thrown).
//
// 3. Throwing an exception gives the caller control: By throwing an
//    ArgumentError, divide() clearly communicates that something went
//    wrong, and the caller (displayResult) can decide how to handle it.
//    Different callers might handle the error differently — one might
//    print a message, another might show a UI dialog, and a test might
//    verify that the exception was thrown correctly.
//
// This reflects the principle that functions should have a single
// responsibility and should be usable in multiple contexts without
// modification.
//
//
// Q10. What does the async keyword on main() allow you to do? Could this
//      assignment have been written without making main() async? Explain.
//
// Answer:
// The async keyword on main() allows us to use the 'await' keyword inside
// the main function. This is essential because we need to wait for each
// displayResult() call to complete (including its 1.5-second simulated
// delay) before starting the next one. This ensures that the output
// appears in the correct sequential order with visible pauses between
// each line, exactly as specified in the assignment.
//
// Technically, the assignment could have been written without making
// main() async. Instead of using await, we could chain .then() callbacks
// on each Future:
//
//   void main() {
//     final calc = Calculator('MyCalculator');
//     calc.displayResult(10, 4, 'add').then((_) {
//       return calc.displayResult(10, 4, 'subtract');
//     }).then((_) {
//       return calc.displayResult(10, 4, 'multiply');
//     }).then((_) {
//       return calc.displayResult(10, 4, 'divide');
//     }).then((_) {
//       print('All calculations complete.');
//     });
//   }
//
// However, this "callback chain" approach is much harder to read,
// maintain, and debug compared to the clean, linear async/await syntax.
// The async/await version reads almost like synchronous code, which is
// its primary advantage. With deeply nested .then() chains (sometimes
// called "callback hell"), the code becomes increasingly indented and
// harder to follow.
//
// Additionally, error handling with .then() requires .catchError() calls,
// which is more verbose than a simple try-catch block. For these reasons,
// making main() async and using await is the idiomatic and recommended
// approach in Dart.
