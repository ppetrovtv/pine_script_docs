Expressions, declarations and statements
========================================

.. contents:: :local:
    :depth: 2

Expressions
-----------

An expression is a sequence of applying both operators and function
calls to operands (variables, values), which determines the calculations
and actions done by the script. Expressions in Pine almost always
produce a result (exceptions are the functions
``study``, ``fill``, ``strategy.entry``, etc. They produce side effects and will be covered
later).

Here are some examples of simple expressions::

    (high + low + close)/3
    sma(high - low, 10) + sma(close, 20)

.. _variable_declaration:

Variable declaration
--------------------

Variables in Pine are declared with the help of the special symbol ``=``
in the following way:

.. code-block:: text

    <identifier> = <expression>

In place of ``<identifier>`` will be the name of the declared variable. Examples of
Variable Declarations::

    src = close
    len = 10
    ma = sma(src, len) + high

Three variables were declared here: ``src``, ``len`` and ``ma``.
Identifiers ``close`` and ``high`` are built-in variables. The
identifier ``sma`` is a built-in function for calculating Simple `Moving
Average <https://www.tradingview.com/wiki/Moving_Average>`__.


.. _variable_assignment:

Variable assignment
-------------------

Mutable variable is such a variable which can be given a new value.

The operator ``:=`` must be used to give a new value to a variable. To use
this operator, a special attribute must be used in the first line of a
code: ``//@version=2``. This attribute identifies the version of Pine
Script. Mutable variables were introduced in version 2.

A variable must be declared before you can set a value for it
(declaration of variables has been described :ref:`above<variable_declaration>`).

Type of a variable is identified on the declaration step. A variable can
be given a value of expression only if both the expression and the
variable belong to the same type, otherwise it will give you a
compilation error.

Variable assignment example::

    //@version=2
    study("My Script")
    price = close
    if hl2 > price
        price := hl2
    plot(price)

We also use an :ref:`'if' statement <if_statement>` in this example.

.. _self_ref_variables:

Self referencing variables
--------------------------

The ability to reference the previous values of declared variables in
expressions where they are declared (using the operator ``[]``) is a
useful feature in Pine. These variables are called *self referencing*
variables. For Example:

::

    //@version=2
    study("Fibonacci numbers")
    fib = na(fib[1]) or na(fib[2]) ? 1 : fib[1] + fib[2]
    plot(fib)

.. note:: self referencing variables and forward referencing variables were
   removed in :ref:`version 3 <pine_script_release_notes_v3>`.

In Pine version 3, this can be achieved using the syntax of :ref:`mutable variables<variable_assignment>`:

::
    
    //@version=3
    study("Fibonacci numbers v3")
    fib = 0
    fib := na(fib[1]) or na(fib[2]) ? 1 : fib[1] + fib[2]
    plot(fib)

See also :doc:`appendix/Pine_version_3_migration_guide`.

**Expert tip**: mod out the Fibonacci numbers by 1000 to generate a plot you
can actually see:

::

    //@version=3
    study("Fibonacci numbers v3")
    fib = 0
    fib := (na(fib[1]) or na(fib[2]) ? 1 : fib[1] + fib[2]) % 1000
    plot(fib)

The variable ``fib`` is a series of Fibonacci numbers : 1, 1, 2, 3, 5,
8, 13, 21, ..., where the first two numbers are equal to 1 and 1 and each
subsequent number is the sum of the last two. In the given example, the
built-in function ``na`` is used and returns ``true`` if the value of
its argument has still not been determined (is ``na``). In the example
produced below, the values ``fib[1]`` and ``fib[2]`` have not been determined on
the first bar, while on the second bar ``fib[2]`` has not been determined.
Finally, on the third bar both of them are defined and can be added.
|images/Fib.png|

.. note:: Since the sequence of Fibonacci numbers grows rather fast, the
   variable ``fib`` very quickly overflows. As such, the user should apply
   the given indicator on the monthly 'M' or yearly 'Y' resolution,
   otherwise the value 'n/a' will be on the chart instead of the Fibonacci
   numbers.

.. _preventing_na_values_functions_na_and_nz:

Preventing ``na`` values, functions ``na`` and ``nz``
-----------------------------------------------------

Self referencing variables allow for the accumulation of values during
the indicator's calculation on the bars. However there is one point to
remember. For example, let's assume we want to count all the bars on the
chart with the following script:

::

    barNum = barNum[1] + 1

The self referencing variable ``barNum`` refers to its own value on the
previous bar, meaning, when the indicator will be calculated on every
bar, the value ``barNum[1]`` will be equal to ``na``. Therefore, on the first
bar ``barNum[1]`` has no value. Adding 1 to ``na`` will still produce the ``na`` as a result. 
In total, the entire ``barNum`` series will be equal on every
bar to ``na``.

In order to avoid similar problems, Pine has a built-in function ``nz``.
This function takes an argument and if it is equal to ``na`` then it
returns 0, otherwise it returns the argument's value. Afterwards, the
problem with the bars' calculation is solved in the following way:

::

    barNum = nz(barNum[1]) + 1

There is an overloaded version of ``nz`` with two arguments which
returns the second argument if the first is equal to ``na``. Further
information about ``nz`` can be found
`here <https://www.tradingview.com/study-script-reference/#fun_nz>`__.

In addition, there is a simple function with one argument that returns a
logical result called ``na``. This function makes it possible to check
if the argument is ``na`` or not. Check it out
`here <https://www.tradingview.com/study-script-reference/#fun_na>`__.

The difference between ``na`` and ``nz``: ``na`` returns a boolean value
(true or false), and is therefore useful in constructing logical
expressions (e.g., ``if na(x)``). ``nz`` is a 'filler', as it fills ``na``
values of a series with zeros (in the case of ``nz(x)``) or with a
user-specified value (in the case of ``nz(x, y)``). Note: the
double-argument version ``nz(x, y)`` is equivalent to the logical
construction ``na(x) ? y : x``. (``?:`` is a :ref:`ternary operator<ternary_operator>`).

Simple moving average without applying the function ``sma``
-----------------------------------------------------------

While using self referencing variables, it's possible to write the
equivalent of the built-in function ``sma`` which calculates the simple
moving average (SMA)::

    study("Pine Script SMA", overlay=true)
    src = close
    len = 9
    sum = nz(sum[1]) - nz(src[len]) + src
    plot(sum/len)

The variable ``sum`` is a moving sum with one window that has a length
``len``. On each bar the variable ``sum`` is equal to its previous value,
then the leftmost value in a moving window is subtracted from ``sum`` and
a new value, which entered the moving window (the rightmost), is added.
This is the algorithm optimized for vector languages, see `Moving
Average <https://www.tradingview.com/wiki/Moving_Average>`__ for a detailed basic algorithm description.

Further, before the graph is rendered, the ``sum`` is divided by the
window size ``len`` and the indicator is displayed on the chart.

.. _if_statement:

``if`` statement
----------------

``if`` statement defines what block of statements must be executed when
conditions of the expression are satisfied.

To have access to and use the ``if`` statement, one should specify the
version of Pine Script language in the very first line of code:
``//@version=2``

General code form:

.. code-block:: text

    <var_declarationX> = if <condition>
        <var_decl_then0>
        <var_decl_then1>
        ...
        <var_decl_thenN>
        <return_expression_then>
    else
        <var_decl_else0>
        <var_decl_else1>
        ...
        <var_decl_elseN>
        <return_expression_else>

where:

-  ``var_declarationX`` --- this variable gets the value of the ``if``
   statement.
-  ``condition`` --- if the ``condition`` expression is true, the logic from the block
   'then' (``var_decl_then0``, ``var_decl_then1``, etc.) is used, if the
   ``condition`` is false, the logic from the block 'else'
   (``var_decl_else0``, ``var_decl_else1``, etc.) is used.
-  ``return_expression_then``, ``return_expression_else`` --- the last
   expression from the block 'then' or from the block 'else' will
   return the final value of the whole ``if`` statement. If declaration of the
   variable is in the end, its value will be the result.

The type of returning value of the ``if`` statement depends on
``return_expression_then`` and ``return_expression_else`` type (their types
must match, it is not possible to return an integer value from the 'then' block,
while you have a string value in the 'else' block).

Example::

    // This code compiles
    x = if close > open
        close
    else
        open
    // This code doesn't compile
    x = if close > open
        close
    else
        "open"

It is possible to omit the ``else`` block. In this case if the ``condition``
is false, an *empty* value (``na``, or ``false``, or ``""``) will be assigned to the
``var_declarationX`` variable.

Example::

    x = if close > open
        close
    // If current close > current open, then x = close.
    // Otherwise the x = na.

The blocks 'then' and 'else' are shifted by 4 spaces [#tabs]_. If statements can
be nested, then add 4 more spaces::

    x = if close > open
        b = if close > close[1]
            close
        else
            close[1]
        b
    else
        open

It is possible to ignore the resulting value of an ``if`` statement
(``var_declarationX =`` can be omited). It may be useful if you need the
side effect of the expression, for example in :doc:`strategy trading<Strategies>`:

::

    if (crossover(source, lower))
        strategy.entry("BBandLE", strategy.long, stop=lower,                    
                       oca_name="BollingerBands",
                       oca_type=strategy.oca.cancel, comment="BBandLE")
    else
        strategy.cancel(id="BBandLE")

.. _for_statement:

``for`` statement
-----------------

``for`` statement allows to execute a number of instructions repeatedly.
To use ``for`` statements, a special attribute must be used in the first
line of a code: ``//@version=2``. This attribute identifies the version
of Pine Script. ``for`` statements were introduced in version 2.

General code form:

.. code-block:: text

    <var_declarationX> = for <i> = <from> to <to> by <step>
        <var_decl0>
        <var_decl1>
        ...
        continue
        ...
        break
        ...
        <var_declN>
        <return_expression>

where:

-  ``i`` --- a loop counter variable.
-  ``from`` --- start value of the counter.
-  ``to`` --- end value of the counter. When the counter becomes greater
   than ``to`` (or less than ``to`` in case ``from > to``) the
   loop is stopped.
-  ``step`` --- loop step. Can be omitted (by default loop step = 1). If
   ``from`` is greater than ``to`` loop step will change direction
   automatically, no need to specify negative numbers.
-  ``var_decl0``, ... ``var_declN``, ``return_expression`` --- body of the loop. It
   must be shifted by 4 spaces [#tabs]_.
-  ``return_expression`` --- returning value. When a loop is finished or
   broken, the returning value is given to the ``var_declarationX``.
-  ``continue`` --- a keyword. Can be used only in loops. It switches the loop
   to the next iteration.
-  ``break`` --- a keyword. Can be used only in loops. It breaks (stops) the loop.

``for`` loop example:

::

    //@version=2
    study("For loop")
    my_sma(price, length) =>
        sum = price
        for i = 1 to length-1
            sum := sum + price[i]
        sum / length
    plot(my_sma(close,14))

Variable ``sum`` is a :ref:`mutable variable <variable_assignment>` and a
new value can be given to it by the operator ``:=`` in body of the loop.
Also note that we recommend to use a built-in function
`sma <https://www.tradingview.com/study-script-reference/#fun_sma>`__
for simple moving average as it calculates faster.

.. |images/Fib.png| image:: images/Fib.png

.. rubric:: Footnotes

.. [#tabs] On TradingView *Pine Editor* the **Tab** key produces 4 spaces automatically.
