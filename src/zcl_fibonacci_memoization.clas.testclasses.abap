CLASS ltcl_test DEFINITION
  FOR TESTING
  DURATION LONG
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_fibonacci_memoization.

    METHODS setup.

    METHODS fib_recursive_16 FOR TESTING.
    METHODS fib_recursive_32 FOR TESTING.
    METHODS fib_recursive_39." FOR TESTING.   " make it "FOR TESTING" to see runtime
    METHODS fib_recursive_40." FOR TESTING.   " make it "FOR TESTING" to see runtime

    METHODS fib_memoized_016 FOR TESTING.
    METHODS fib_memoized_032 FOR TESTING.
    METHODS fib_memoized_064 FOR TESTING.
    METHODS fib_memoized_128 FOR TESTING.
    METHODS fib_memoized_150 FOR TESTING.

    METHODS fib_loop_016 FOR TESTING.
    METHODS fib_loop_032 FOR TESTING.
    METHODS fib_loop_064 FOR TESTING.
    METHODS fib_loop_128 FOR TESTING.
    METHODS fib_loop_150 FOR TESTING.

    METHODS fib_math_016 FOR TESTING.
    METHODS fib_math_032 FOR TESTING.
    METHODS fib_math_064 FOR TESTING.
    METHODS fib_math_128 FOR TESTING.
    METHODS fib_math_150 FOR TESTING.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.

    cut = NEW zcl_fibonacci_memoization( ).

  ENDMETHOD.

  METHOD fib_recursive_16.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_recursive( 16 )
                                        exp = 987 ).

  ENDMETHOD.

  METHOD fib_recursive_32.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_recursive( 32 )
                                        exp = 2178309 ).

  ENDMETHOD.

  METHOD fib_recursive_39.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_recursive( 39 )
                                        exp = 63245986 ).

  ENDMETHOD.

  METHOD fib_recursive_40.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_recursive( 40 )
                                        exp = 102334155 ).

  ENDMETHOD.

  METHOD fib_memoized_016.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_memoized( 16 )
                                        exp = 987 ).

  ENDMETHOD.

  METHOD fib_memoized_032.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_memoized( 32 )
                                        exp = 2178309 ).

  ENDMETHOD.

  METHOD fib_memoized_064.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_memoized( 64 )
                                        exp = 10610209857723 ).

  ENDMETHOD.

  METHOD fib_memoized_128.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_memoized( 128 )
                                        exp = 251728825683549488150424261 ).

  ENDMETHOD.

  METHOD fib_memoized_150.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_memoized( 150 )
                                        exp = 9969216677189303386214405760200 ).

  ENDMETHOD.

  METHOD fib_loop_016.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_loop( 16 )
                                        exp = 987 ).

  ENDMETHOD.

  METHOD fib_loop_032.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_loop( 32 )
                                        exp = 2178309 ).

  ENDMETHOD.

  METHOD fib_loop_064.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_loop( 64 )
                                        exp = 10610209857723 ).

  ENDMETHOD.

  METHOD fib_loop_128.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_loop( 128 )
                                        exp = 251728825683549488150424261 ).

  ENDMETHOD.

  METHOD fib_loop_150.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_loop( 150 )
                                        exp = 9969216677189303386214405760200 ).

  ENDMETHOD.

  METHOD fib_math_016.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_math( 16 )
                                        exp = 987 ).

  ENDMETHOD.

  METHOD fib_math_032.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_math( 32 )
                                        exp = 2178309 ).

  ENDMETHOD.

  METHOD fib_math_064.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_math( 64 )
                                        exp = 10610209857723 ).

  ENDMETHOD.

  METHOD fib_math_128.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_math( 128 )
                                        exp = 251728825683549488150424261 ).

  ENDMETHOD.

  METHOD fib_math_150.

    cl_abap_unit_assert=>assert_equals( act = cut->fib_math( 150 )
                                        exp = 9969216677189303386214405760200 ).

  ENDMETHOD.

ENDCLASS.
