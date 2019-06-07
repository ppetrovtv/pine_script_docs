Operators
=========

.. contents:: :local:
    :depth: 2

Arithmetic operators 
--------------------

There are five arithmetic operators in Pine Script:

+-------+------------------------------------+
| ``+`` | Addition                           |
+-------+------------------------------------+
| ``-`` | Subtraction                        |
+-------+------------------------------------+
| ``*`` | Multiplication                     |
+-------+------------------------------------+
| ``/`` | Division                           |
+-------+------------------------------------+
| ``%`` | Take the remainder after dividing  |
+-------+------------------------------------+

Arithmetic operators above are binary. The type of result depends on
the type of operands. If at least one of the operands is a *series*, then
the result also will have a *series* type. If both operands are numeric,
but at least one of these has the type *float*, then the result will
also have the type *float*. If both operands are *integers*, then the
result will also have the type *integer*.

Footnote: if at least one operand is ``na`` then the result is also
``na``. 

Comparison operators
--------------------

There are six comparison operators in Pine Script:

+--------+---------------------------------+
| ``<``  | Less Than                       |
+--------+---------------------------------+
| ``<=`` | Less Than or Equal To           |
+--------+---------------------------------+
| ``!=`` | Not Equal                       |
+--------+---------------------------------+
| ``==`` | Equal                           |
+--------+---------------------------------+
| ``>``  | Greater Than                    |
+--------+---------------------------------+
| ``>=`` | Greater Than                    |
+--------+---------------------------------+

Comparison operations are binary. The result is determined by the type
of operands. If at least one of these operands has a *series* type, then
the type of result will also be the *series* (a series of logical
values). If both operands have a numerical type, then the result will be
of the logical type *bool*.

Logical operators
-----------------

There are three logical operators in Pine Script:

+---------+---------------------------------+
| ``not`` | Negation                        |
+---------+---------------------------------+
| ``and`` | Logical Conjunction             |
+---------+---------------------------------+
| ``or``  | Logical Disjunction             |
+---------+---------------------------------+

All logical operators can operate with *bool* operands, numerical
operands, or series type operands. Similar to arithmetic and comparison
operators, if at least one of these operands of an operator has a *series*
type, than the result will also have a *series* type. In all other cases
the operator's type of result will be the logical type *bool*.

The operator ``not`` is unary. If an operator's operand has a ``true``
value then the result will have a ``false`` value; if the operand has a
``false`` value then the result will have a ``true`` value.

``and`` operator truth table:

+---------+---------+-----------+
| a       | b       | a and b   |
+=========+=========+===========+
| true    | true    | true      |
+---------+---------+-----------+
| true    | false   | false     |
+---------+---------+-----------+
| false   | true    | false     |
+---------+---------+-----------+
| false   | false   | false     |
+---------+---------+-----------+

``or`` operator truth table:

+---------+---------+----------+
| a       | b       | a or b   |
+=========+=========+==========+
| true    | true    | true     |
+---------+---------+----------+
| true    | false   | true     |
+---------+---------+----------+
| false   | true    | true     |
+---------+---------+----------+
| false   | false   | false    |
+---------+---------+----------+

.. _ternary_operator:

Conditional operator ``?:`` and the function ``iff``
----------------------------------------------------

`Conditional ternary
operator <https://www.tradingview.com/study-script-reference/#op_%7Bquestion%7D%7Bcolon%7D>`__
calculates the first expression (condition) and returns a value either
of the second operand (if the condition is ``true``) or of the third
operand (if the condition is ``false``). Syntax::

    condition ? result1 : result2

If ``condition`` will be calculated to ``true``, then ``result1`` will be the
result of all ternary operator, otherwise, ``result2`` will be the result.

The combination of a few conditional operators helps to build
constructions similar to *switch* statements in other languages. For
example::

    isintraday ? red : isdaily ? green : ismonthly ? blue : na

The given example will be calculated in the following order (brackets
show the processing order of the given expression)::

    isintraday ? red : (isdaily ? green : (ismonthly ? blue : na))

First the condition ``isintraday`` is calculated; if it is ``true`` then
``red`` will be the result. If it is ``false`` then ``isdaily`` is calculated,
if this is ``true``, then ``green`` will be the result. If this is
``false``, then ``ismonthly`` is calculated. If it is ``true``, then ``blue``
will be the result, otherwise it will be the ``na`` value. For those who find
using the operator syntax ``?:`` inconvenient, in Pine there is an
alternative (with equivalent functionality) --- the built-in function
``iff``. The function has the following signature::

    iff(condition, result1, result2)

The function acts identically to the operator ``?:``, i.e., if the
condition is ``true`` then it returns ``result1``, otherwise --- ``result2``. The
previous example using ``iff`` will look like::

    iff(isintraday, red, iff(isdaily, green,
                         iff(ismonthly, blue, na)))

.. _history_referencing_operator:

History reference operator ``[]``
---------------------------------

It is possible to refer to the historical values of any variable of a
*series* type (values which the variable had on the previous bars) with
the ``[]`` operator. For example, we will assume that we have the
variable ``close``, containing 10 values (that correspond to a chart
with a certain hypothetical symbol with 10 bars):

+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
| Index   | 0       | 1       | 2       | 3       | 4       | 5       | 6       | 7       | 8       | 9       |
+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
| close   | 15.25   | 15.46   | 15.35   | 15.03   | 15.02   | 14.80   | 15.01   | 12.87   | 12.53   | 12.43   |
+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+

Applying the operator ``[]`` with arguments 1, 2, 3, we will receive the
following vector:

+------------+-------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
| Index      | 0     | 1       | 2       | 3       | 4       | 5       | 6       | 7       | 8       | 9       |
+------------+-------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
| close[1]   | ``na``| 15.25   | 15.46   | 15.35   | 15.03   | 15.02   | 14.80   | 15.01   | 12.87   | 12.53   |
+------------+-------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
| close[2]   | ``na``| ``na``  | 15.25   | 15.46   | 15.35   | 15.03   | 15.02   | 14.80   | 15.01   | 12.87   |
+------------+-------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
| close[3]   | ``na``| ``na``  | ``na``  | 15.25   | 15.46   | 15.35   | 15.03   | 15.02   | 14.80   | 15.01   |
+------------+-------+---------+---------+---------+---------+---------+---------+---------+---------+---------+

When a vector is shifted, a special ``na`` value is pushed to vector's
tail. ``na`` means that the numerical value based on the given index is
absent (*not available*). The values to the right, which do not have enough space to be
placed in a vector of a line of 10 elements are simply removed. The
value from the vector's head is "popped". In the given example the index
of the current bar is equal to 9. The value of the vector ``close[1]`` on the current bar will be equal 
to the previous value of the initial vector ``close``. 
The value ``close[2]`` will be equal to the value ``close`` two bars ago, etc.

So the operator ``[]`` can be thought of as the history referencing
operator.

**Note 1**. Almost all built-in functions in Pine's standard library
return a series result, for example the function ``sma``. Therefore it's
possible to apply the operator ``[]`` directly to the function calls:

::

    sma(close, 10)[1]

**Note 2**. Despite the fact that the operator ``[]`` returns the result
of the series type, it's prohibited to apply this operator to the same
operand over and over again. Here is an example of incorrect use:

::

    close[1][2] // Error: incorrect use of operator []

A compilation error message will appear.

In some situations, the user may want to shift the series to the left.
Negative arguments for the operator ``[]`` are prohibited. This can be
accomplished using ``offset`` argument in ``plot`` annotation. It
supports both positive and negative values. Note, though that it is a
visual shift., i.e., it will be applied after all the calculations.
Further details about ``plot`` and its arguments can be found
`here <https://www.tradingview.com/study-script-reference/#fun_plot>`__.

There is another important consideration when using operator ``[]`` in
Pine Scripts. The indicator executes a calculation on each bar,
beginning from the oldest existing bar until the most recent one (the
last). As seen in the table, ``close[3]`` has ``na`` values on the
first three bars. ``na`` represents a value which is not a number and
using it in any math expression will result in also ``na`` (similar 
to `NaN <https://en.wikipedia.org/wiki/NaN>`__). So your
code should specifically handle ``na`` values using functions :ref:`na and
nz <preventing_na_values_functions_na_and_nz>`.

Priority of operators
---------------------

The order of the calculations is determined by the operators' priority.
Operators with greater priority are calculated first. Below are a list
of operators sorted by decreasing priority:

+------------+-------------------------------------+
| Priority   | Operator Symbol                     |
+============+=====================================+
| 9          | ``[]``                              |
+------------+-------------------------------------+
| 8          | unary ``+``, unary ``-``, ``not``   |
+------------+-------------------------------------+
| 7          | ``*``, ``%``                        |
+------------+-------------------------------------+
| 6          | ``+``, ``-``                        |
+------------+-------------------------------------+
| 5          | ``>``, ``<``, ``>=``, ``<=``        |
+------------+-------------------------------------+
| 4          | ``==``, ``!=``                      |
+------------+-------------------------------------+
| 3          | ``and``                             |
+------------+-------------------------------------+
| 2          | ``or``                              |
+------------+-------------------------------------+
| 1          | ``?:``                              |
+------------+-------------------------------------+

If in one expression there are several operators with the same priority,
then they are calculated left to right.

If it's necessary to change the order of calculations to calculate the
expression, then parts of the expression should be grouped together with
parentheses.
