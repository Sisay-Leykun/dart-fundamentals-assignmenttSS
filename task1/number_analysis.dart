// Task 1: Number Analysis App
// Name: Sisay Leykun
// Student ID: ATE/0493/15 (additional)

int findMax(List<int> numbers) {
  /// Finds the maximum value in a list of integers.
  // Hint: start with the first element as your initial max
  if (numbers.isEmpty) {
    print('Error: List is empty for findMax');
    return 0; // Empty List Guard (1.7 bonus - 2 pts)
  }
  int max = numbers[0];
  for (int num in numbers) {
    if (num > max) max = num;
  }
  return max;
}

int findMin(List<int> numbers) {
/// Finds the minimum value in a list of integers.
  if (numbers.isEmpty) {
    print('Error: List is empty for findMin');
    return 0; // Empty List Guard (1.7 bonus - 2 pts)
  }
  int min = numbers[0];
  for (int num in numbers) {
    if (num < min) min = num;
  }
  return min;
}

int calculateSum(List<int> numbers) {
/// Calculates the sum of all numbers in a list.
  if (numbers.isEmpty) {
    print('Error: List is empty for calculateSum');
    return 0; // Empty List Guard (1.7 bonus - 2 pts)
  }
  int sum = 0;
  for (int num in numbers) {
    sum += num;
  }
  return sum;
}

double calculateAverage(List<int> numbers) {
/// Calculates the average value of numbers in a list.
/// This reuses calculateSum() to follow the DRY principle.
  // Hint: call calculateSum() here, then divide
  if (numbers.isEmpty) {
    print('Error: List is empty for calculateAverage');
    return 0.0; // Empty List Guard (1.7 bonus - 2 pts)
  }
  return calculateSum(numbers) / numbers.length; // reuses calculateSum as required
}

//  1.7 OPTIONAL CHALLENGE EXTENSIONS (ALL 4) 

// Count Negatives 
int countNegatives(List<int> numbers) {
  int count = 0;
  for (int num in numbers) {
    if (num < 0) count++;
  }
  return count;
}

// Sorted Output- returns a NEW sorted list (ascending) without using .sort()
List<int> getSorted(List<int> numbers) {
  if (numbers.isEmpty) {
    print('Error: List is empty for getSorted');
    return [];
  }
  List<int> sorted = List.from(numbers); // new list (original unchanged)
  // Manual bubble sort (simple sorting algorithm as requested)
  for (int i = 0; i < sorted.length - 1; i++) {
    for (int j = 0; j < sorted.length - i - 1; j++) {
      if (sorted[j] > sorted[j + 1]) {
        int temp = sorted[j];
        sorted[j] = sorted[j + 1];
        sorted[j + 1] = temp;
      }
    }
  }
  return sorted;
}

// Collection Methods Comparison - both versions kept with trade-off comment
// Trade-off: Manual loops (required for learning) teach control flow.
// Built-in methods (.reduce, .fold) are shorter, faster, and more readable in real apps
// but hide the implementation details.
int findMaxBuiltIn(List<int> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.reduce((a, b) => a > b ? a : b);
}

int findMinBuiltIn(List<int> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.reduce((a, b) => a < b ? a : b);
}

int calculateSumBuiltIn(List<int> numbers) {
  if (numbers.isEmpty) return 0;
  // ignore: avoid_types_as_parameter_names
  return numbers.fold(0, (sum, num) => sum + num);
}

double calculateAverageBuiltIn(List<int> numbers) {
  if (numbers.isEmpty) return 0.0;
  return calculateSumBuiltIn(numbers) / numbers.length;
}

void main() {
  final numbers = <int>[34, -7, 89, 12, -45, 67, 3, 100, -2, 55];

  // Call each function and print the result
  print('Number Analysis Results');
  print('========================');
  print('Numbers: $numbers');
  print('Maximum value : ${findMax(numbers)}');
  print('Minimum value : ${findMin(numbers)}');
  print('Sum           : ${calculateSum(numbers)}');
  print('Average       : ${calculateAverage(numbers)}');
  
  // 1.7 Challenge outputs
  print('Negative count (Count Negatives): ${countNegatives(numbers)}');
  print('Sorted list (Sorted Output): ${getSorted(numbers)}');

   print('Built-in Max  : ${findMaxBuiltIn(numbers)}');

  print('Built-in Min  : ${findMinBuiltIn(numbers)}');

  print('Built-in Sum  : ${calculateSumBuiltIn(numbers)}');

  print('Built-in Avg  : ${calculateAverageBuiltIn(numbers)}');
}
//           CONCEPTUAL QUESTIONS (Task 1) 
//
// Q1. What is the difference between a List<int> and a List<dynamic>
//     in Dart? Why is it usually better to use a typed list like List<int>?
//
// Answer:
// A List<int> is a type-safe collection that can only hold integer values.
// The Dart compiler enforces this constraint at compile time, meaning if
// you accidentally try to add a String, double, or any non-integer value
// to a List<int>, you will get a compile-time error before the program
// even runs. This catches bugs early in development.
//
// A List<dynamic>, on the other hand, can hold values of any type —
// integers, strings, booleans, objects, and even null — all in the same
// list. While this flexibility might seem convenient, it removes the
// compiler's ability to check types for you. This means type-related
// bugs only appear at runtime, which makes them harder to find and fix.
//
// It is usually better to use List<int> because:
// 1. Type safety: The compiler catches type errors before the program runs.
// 2. Readability: Anyone reading the code immediately knows what kind of
//    data the list contains.
// 3. IDE support: The IDE can provide better autocomplete suggestions and
//    documentation for int-specific methods and properties.
// 4. Performance: The Dart runtime can optimize operations on typed lists
//    because it knows the exact type of every element.
// 5. Self-documentation: The type annotation serves as documentation about
//    the programmer's intent.
//
// 
//
// Q2. In your findMax() function, why is it important to initialize your
//     'running maximum' variable to the first element of the list rather
//     than to 0 or to a very small number? What could go wrong with the
//     other approaches?
//
// Answer:
// If you initialize the running maximum to 0, the function will produce
// incorrect results for lists that contain only negative numbers. For
// example, with the list [-5, -3, -8], the correct maximum is -3.
// However, if max starts at 0, none of the negative numbers are greater
// than 0, so the loop never updates max, and the function incorrectly
// returns 0 — a value that is not even in the list.
//
// If you initialize to a "very small number" like -999999, this approach
// is fragile and unreliable. Someone could pass a list with values
// smaller than your chosen constant (e.g., [-1000000, -2000000]), and
// the function would return -999999 instead of the actual maximum. There
// is no safe "small enough" number to choose because integers can be
// arbitrarily large or small.
//
// By initializing to numbers[0] (the first element of the list), you
// guarantee that the running maximum is always a value that actually
// exists in the list. Every subsequent comparison is valid because you
// are comparing list elements against another list element. This approach
// works correctly regardless of whether the numbers are all positive,
// all negative, mixed, or contain duplicates.
//
// 
//
// Q3. Your calculateAverage() function calls calculateSum() internally.
//     What software design principle does this demonstrate, and why is
//     reusing existing functions preferable to duplicating code?
//
// Answer:
// This demonstrates the DRY principle — "Don't Repeat Yourself." The
// DRY principle states that every piece of knowledge or logic should
// have a single, authoritative representation in a system. By calling
// calculateSum() inside calculateAverage(), we reuse the summation
// logic that has already been written, tested, and verified.
//
// If we had copied the summing loop into calculateAverage() instead,
// we would have two separate places in the code performing the same
// operation. This creates several problems:
// 1. Maintenance burden: If we discover a bug in the summing logic,
//    we must remember to fix it in both places.
// 2. Inconsistency risk: Over time, the two copies might diverge,
//    leading to subtle differences in behavior.
// 3. Code bloat: The program becomes unnecessarily longer and harder
//    to read.
//
// Reusing functions also supports the Single Responsibility Principle:
// calculateSum() has one job (summing), and calculateAverage() has one
// job (computing the average). Each function is focused, testable, and
// easy to understand.
//
//
// Q4. Describe in plain English what the for-in loop syntax does in Dart.
//     How is it different from a traditional for loop with an index?
//     When would you prefer one over the other?
//
// Answer:
// A for-in loop iterates through each element in a collection one at a
// time, automatically assigning the current element to a loop variable.
// When you write "for (int number in numbers)", Dart starts at the first
// element of the list, assigns it to the variable "number", executes the
// loop body, then moves to the second element, assigns it to "number",
// executes the loop body again, and continues until every element has
// been visited.
//
// A traditional for loop with an index — written as
// "for (int i = 0; i < numbers.length; i++)" — gives you access to both
// the index position (i) and the element at that position (numbers[i]).
// You manually control the loop counter, the condition, and the increment.
//
// Key differences:
// - for-in: simpler syntax, less error-prone, no index variable needed.
// - traditional for: provides the index, allows non-sequential iteration
//   (e.g., skipping elements, iterating in reverse, custom step sizes).
//
// I would prefer a for-in loop when I only need the values themselves
// and don't care about their positions. It is cleaner, more readable,
// and eliminates the risk of off-by-one index errors. I would use a
// traditional for loop when I need the index — for example, when
// comparing adjacent elements (as in bubble sort), modifying elements
// in place, iterating in reverse, or skipping every other element.
//
//
// Q5. If someone calls your findMax() function with an empty list, what
//     happens? How could you modify the function to handle that case 
// safely?
//
// Answer:
// Without any guard clause, calling findMax() with an empty list would
// cause a RangeError at the line "int max = numbers[0]" because there is
// no element at index 0 in an empty list. The program would crash with
// an unhandled exception and a stack trace.
//
// To handle this safely, I added an empty list guard at the beginning of
// the function:
//   if (numbers.isEmpty) {
//     print('Error: Cannot find maximum of an empty list.');
//     return 0;
//   }
//
// This checks whether the list is empty before attempting to access any
// elements. If it is empty, the function prints a descriptive error
// message and returns a default value of 0.
//
//

