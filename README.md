# ABAP Memoization example using the Fibonacci Sequence
I recently needed to drastically improve performance of a recursive method, and memoization was there to save the day.
I'd like to demonstrate the technique, in case you're not familiar with it, using the recursive Fibonacci sequence as a base.

FAQ:

Q: Was the Fibonacci calculation what I needed to improve performance for?

A: No, but the recursive Fibonacci calculation is a great and simple example that lends very well to memoization demonstration.


Q: Aren't there better performing ways to calculate the Fibonacci sequence than the recursive method?

A: Well, yes, but I need somthing "slow" to demonstrate the memoization 🙂 I have included two other options in the end, for good measure... (Although one could argue that the recursive function is the "right" way to do it)


Q: What's memoization?

A:
> In computing, memoization or memoisation is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls to pure functions and returning the cached result when the same inputs occur again

See https://en.wikipedia.org/wiki/Memoization

Recursion is not a prerequisite for optimizing by memoization - any pure function can benefit from it. "Pure" in this sense means that any given input always returns the same result, and there are no "side-effects", like changing parameters, database updates, non-local data, etc.


## Fibonacci Sequence
The [Fibonacci Sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence) is a mathematical sequence in which each number is the sum of the two preceding numbers.
The n:th number in the sequence is f(n) = f(n-1) + f(n-2), with f(0) = 0 and f(1) = 1, making the sequence start with 0, 1, 1, 2, 3, 5, 8, 13, 21...

Writing this in ABAP is quite simple with the method definition:
```ABAP
METHODS fib_recursive
  IMPORTING
    n             TYPE i
  RETURNING
    VALUE(result) TYPE decfloat34.
```
and implementation
```ABAP
METHOD fib_recursive.
  CASE n.
    WHEN 0.
      result = 0.
    WHEN 1.
      result = 1.
    WHEN OTHERS.
      result = fib_recursive( n - 1 ) + fib_recursive( n - 2 ).
  ENDCASE.
ENDMETHOD.
```
(Note: For simplicity, there's no input validation for negative n, checks for overflow, and such...)

This performs ok for low n, but will soon prove to be quite costly, and this is why it's a good example to demonstrate memoization. Here are the results from running units tests for some numbers:
| n  | Runtime |
|----|---------|
| 16 | <0.01s  |
| 32 | 1.66s   |
| 39 | 47.39s  |
| 40 | 76s     |

I don't have the patience to wait for the 41 😁. The reason this is slow is because we calculate the previous two numbers for every number we want, and this is not an efficient way.
For instance, when we want f(6), as in the diagram below, the system has to calculate f(4) 2 times, f(3) 3 times and f(2) 5 times.

![image](https://github.com/joltdx/abap-memoization-example/assets/74537631/499e3fdb-c3e3-4004-b8ae-df1a87040c01)

It's the repetitions that makes this an expensive function in this case, but there can be many other reasons for an expensive function.

## Making it memoized
So, while no problem for really low numbers, we see that n = 32 already takes 1.66 seconds, and n = 40 a whopping 76 seconds.
As this is a pure function, we can simply declare a memoization table to store the results the first time we calculate a certain f(n). The next time we want that number, we just read it from our memoization table instead of calculating again.

Definition (the method definition is the same as before)
```ABAP
TYPES:
  BEGIN OF ty_fibonacci_memoized,
    n         TYPE i,
    fibonacci TYPE decfloat34,
  END OF ty_fibonacci_memoized.

DATA fibonacci_memoized TYPE HASHED TABLE OF ty_fibonacci_memoized WITH UNIQUE KEY n.

METHODS fib_memoized
  IMPORTING
    n             TYPE i
  RETURNING
    VALUE(result) TYPE decfloat34.
```

Implementation:
```ABAP
METHOD fib_memoized.
  READ TABLE fibonacci_memoized WITH KEY n = n ASSIGNING FIELD-SYMBOL(<fibonacci_memoized>).
  IF sy-subrc = 0.
    result = <fibonacci_memoized>-fibonacci.
    RETURN.
  ENDIF.

  CASE n.
    WHEN 0.
      result = 0.
    WHEN 1.
      result = 1.
    WHEN OTHERS.
      result = fib_memoized( n - 1 ) + fib_memoized( n - 2 ).
  ENDCASE.

  INSERT VALUE #( n = n fibonacci = result ) INTO TABLE fibonacci_memoized.
ENDMETHOD.
```
Compared to before, we still have the special cases for 0 and 1, but when it's time to calculate recursively, we first check to see if we already have that answer.
If we do, we simply set it as the result. If not, we calculate as before, and when we have gotten the result, we store it in the memoization table for the next time we have the same input.

Now, runtimes are greatly improved:
| n   | Runtime |
|-----|---------|
| 16  | <0.01s  |
| 32  | <0.01s  |
| 64  | <0.01s  |
| 128 | <0.01s  |
| 150 | <0.01s  |

Finishes in no time... What's stopping us from going higher is the decfloat34 datatype and I don't have the [CL_ABAP_BIGINT](https://blogs.sap.com/2023/08/09/new-classes-for-arbitrary-precision-arithmetic-in-abap/) class. Decfloat34 does not fit the answer for n > 150 😅
For reference f(150) is 9969216677189303386214405760200

This ends the demo of memoization. It's not really any harder than a lookup table and inserting calculated results into it.

## Non-recursive implementations
For memoization demonstration purposes, the recursive method is a great base, but as promised, there are also other ways to calculate the Fibonacci sequence numbers if need be, without recursion. They are also pure and could be memoized too, of course, but they do not suffer from the extreme cost as the recursive method.

With the same definitions as before, here's an implementation using a DO/ENDDO loop:
```ABAP
METHOD fib_loop.
    DATA fib_n_minus_one TYPE decfloat34.
    DATA fib_n_minus_two TYPE decfloat34.

    IF n = 0.
      result = 0.
    ELSEIF n = 1.
      result = 1.
    ELSEIF n = 2.
      result = 1.
    ENDIF.
    fib_n_minus_one = 1.
    fib_n_minus_two = 1.

    DO n - 2 TIMES.
      result = fib_n_minus_one + fib_n_minus_two.
      fib_n_minus_two = fib_n_minus_one.
      fib_n_minus_one = result.
    ENDDO.
ENDMETHOD.
```
And here's and example using the closed form formula:
```ABAP
METHOD fib_math.
  result = round( val = 1 / sqrt( 5 ) * ( ( ( 1 + sqrt( 5 ) ) / 2 ) ** n - ( ( 1 - sqrt( 5 ) ) / 2 ) ** n )
                  dec = 0 ).
ENDMETHOD.
```
Both these non-recursive methods also calculate in <0.01s on my system
