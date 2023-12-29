CLASS zcl_fibonacci_memoization DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS fib_recursive
      IMPORTING
        n             TYPE i
      RETURNING
        VALUE(result) TYPE decfloat34.

    METHODS fib_memoized
      IMPORTING
        n             TYPE i
      RETURNING
        VALUE(result) TYPE decfloat34.

    METHODS fib_loop
      IMPORTING
        n             TYPE i
      RETURNING
        VALUE(result) TYPE decfloat34.

    METHODS fib_math
      IMPORTING
        n             TYPE i
      RETURNING
        VALUE(result) TYPE decfloat34.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_fibonacci_memoized,
        n         TYPE i,
        fibonacci TYPE decfloat34,
      END OF ty_fibonacci_memoized.

    DATA fibonacci_memoized TYPE HASHED TABLE OF ty_fibonacci_memoized WITH UNIQUE KEY n.

ENDCLASS.



CLASS zcl_fibonacci_memoization IMPLEMENTATION.

  METHOD fib_recursive.
    " Recursive method, no memoization
    " f(n) = f(n-1)+f(n-2)

    CASE n.
      WHEN 0.
        result = 0.

      WHEN 1.
        result = 1.

      WHEN OTHERS.
        result = fib_recursive( n - 1 ) + fib_recursive( n - 2 ).

    ENDCASE.

  ENDMETHOD.

  METHOD fib_memoized.
    " Recursive method, with memoization
    " f(n) = f(n-1)+f(n-2)

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

  METHOD fib_loop.
    " Calculate the n:th number of the Fibonacci sequence in a simple DO/ENDDO loop.

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

  METHOD fib_math.
    " Mathing our way to the number using a closed form of the Fibonacci sequence
    " http://mathonline.wikidot.com/a-closed-form-of-the-fibonacci-sequence

    result = round( val = 1 / sqrt( 5 ) * ( ( ( 1 + sqrt( 5 ) ) / 2 ) ** n - ( ( 1 - sqrt( 5 ) ) / 2 ) ** n )
                    dec = 0 ).

  ENDMETHOD.

ENDCLASS.
