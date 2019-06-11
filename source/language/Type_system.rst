Type system
===========

.. contents:: :local:
    :depth: 2

.. include:: <isonum.txt>

Pine has 7 fundamental data **types**. They are: 
*int*, *float*, *bool*, *color*, *string*, *line*, *label*. 
All of these types exist in several **forms**. There are 5 forms of types:
*literal*, *const*, *input*, *simple* and a *series*. The Pine compiler distinguishes 
between a *literal bool* type, an *input bool* type, a *series bool* type and so on.

There is also a *void* type, a *na* (not available) type and a compound *tuple* type.

Type forms
----------

Literal
^^^^^^^

A *literal* is a special notation for representing a fixed value in Pine. This fixed value itself is an 
expression and such literal expressions are always of one of the 4 following types:
    
    * *literal float* (e.g. ``3.14``)
    * *literal int* (e.g. ``42``)
    * *literal bool* (e.g. ``true``, ``false``)
    * *literal string* (e.g. ``"A text literal"``)

.. note:: In Pine, the built-in names ``open``, ``high``, ``low``, ``close``, ``volume``, ``time``, 
    ``hl2``, ``hlc3``, ``ohlc4`` are not literals. They are of the *series* type.

Const
^^^^^

Values of the form *const* are ones that:
    
    * do not change during the script execution
    * are known or can be calculated at compile time

For example::
    
    c1 = 0
    c2 = c1 + 1
    c3 = c1 + 1
    if open > close
        c3 := 0

The type of ``c1`` is *const float* because it is initialized with a *literal* expression.
The type of ``c2`` is *const float* too, because it is initialized with an arithmetic expression of *const float* type.
The type of ``c3`` is *series float* because it changes at runtime.

Input
^^^^^

Values of the form *input* are ones that:

    * do not change during script execution
    * are unknown at compile time
    * originate from an `input <https://www.tradingview.com/study-script-reference/v4/#fun_input>`__ function

For example::

    p = input(10, title="Period")

Type of ``p`` variable is *input integer*. 

Simple
^^^^^^

Values of the form *simple* are ones that:

    * do not change during script execution
    * are unknown at compile time

They are values that come from the main chart symbol information. For example, 
the `syminfo.mintick <https://www.tradingview.com/study-script-reference/v4/#var_syminfo{dot}mintick>`__
built-in variable is a *simple float*. The word *simple* is usually omitted when referring to this form, 
so we use *float* rather than *simple float*.

Series
^^^^^^

Values of the form *series* are ones that:

    * change during the script execution
    * store a sequence of historical values associated with bars of the main chart's symbol
    * can be accessed using the ``[]`` operator. Note that only the last value in the series, i.e. the one associated with the current bar, is available for both reading and writing

The *series* form is the most common form in Pine.
Examples of built-in *series* variables are: ``open``, ``high``, ``low``,
``close``, ``volume`` and ``time``. The size of these lists are equal to the
quantity of available bars based on the current ticker and timeframe
(resolution). The series may contain numbers or a special value: ``na``
(meaning that a value is *not available*. Further information about ``na`` values
can be found :ref:`here <history_referencing_operator>`). 
Any expression that contains a series variable will be treated as a
series itself. For example::

    a = open + close // Addition of two series
    b = high / 2     // Division of a series variable by
                     // an integer literal constant
    c = close[1]     // Referring to the previous ``close`` value

.. note:: The ``[]`` operator also returns a value of the *series* form.

Fundamental types
-----------------

int
^^^

Integer literals must be written in decimal notation.
For example::

    1
    750
    94572
    100

There are 5 forms of int type in Pine:

    * *literal int*
    * *const int*
    * *input int*
    * *int* 
    * *series int*

float
^^^^^

Floating-point literals contain a
delimiter (the symbol ``.``) and may also contain the symbol ``e`` (which means
"multiply by 10 to the power of X", where X is the number after the
symbol ``e``). Examples::

    3.14159    // 3.14159
    6.02e23    // 6.02 * 10^23
    1.6e-19    // 1.6 * 10^-19
    3.0        // 3.0

The first number is the rounded number Pi (π), the second number is very
large, while the third is very small. The fourth number is simply the
number ``3`` as a floating point number.

.. note:: It's possible to use uppercase ``E`` instead of lowercase ``e``.

There are 5 forms of float type in Pine:

    * *literal float*
    * *const float*
    * *input float*
    * *float* 
    * *series float*

bool
^^^^

There are only two literals for representing logical values::

    true    // true value
    false   // false value

There are 5 forms of bool type in Pine:

    * *literal bool*
    * *const bool*
    * *input bool*
    * *bool* 
    * *series bool*


color
^^^^^

Color literals have the following format: ``#`` followed by 6 or 8
hexadecimal digits matching RGB or RGBA value. The first two digits
determine the value for the **red** color component, the next two, 
**green**, and the third, **blue**. 
Each component value must be a hexadecimal number from ``00`` to ``FF`` (0 and 255 in decimal).

The fourth pair of digits is optional. When used, it specifies the **alpha** (opacity) 
component, a value also from ``00`` (fully transparent) to ``FF`` (fully opaque).
Examples::

    #000000                // black color
    #FF0000                // red color
    #00FF00                // green color
    #0000FF                // blue color
    #FFFFFF                // white color
    #808080                // gray color
    #3ff7a0                // some custom color
    #FF000080              // 50% transparent red color
    #FF0000FF              // same as #00FF00, fully opaque red color
    #FF000000              // completely transparent color

.. note:: Hexadecimal notation is not case-sensitive.

There are 5 forms of color type in Pine:

    * *literal color*
    * *const color*
    * *input color*
    * *color*
    * *series color*

One might wonder how to get a value of type *input color* if there is no color 
`input <https://www.tradingview.com/study-script-reference/v4/#fun_input>`__ in Pine. The answer is, 
with an arithmetic expression with other input types and color literals/constants. For example::

   b = input(true, "Use red color")
   c = b ? color.red : #000000  // c has color input type

There is an arithmetic expression with Pine ternary operator ``?:`` which involves
three different types: ``b`` of type *input bool*, ``color.red`` of type *const color* and ``#000000`` of 
type *literal color*. Pine compiler takes into account two things: Pine automatic type casting rules (see below), 
and available overloads of operator ``?:``. Thus the resulting type is the most narrow type that could be 
auto casted to and this is *input color* type.

Apart from configuring a color value directly with a literal (in hexadecimal format), 
in the language there are more convenient, built-in variables of the type *color*. For
basic colors there are: ``color.black``, ``color.silver``, ``color.gray``, ``color.white``,
``color.maroon``, ``color.red``, ``color.purple``, ``color.fuchsia``, ``color.green``, ``color.lime``,
``color.olive``, ``color.yellow``, ``color.navy``, ``color.blue``, ``color.teal``, ``color.aqua``,
``color.orange``. 

It is possible to change transparency of the color using
built-in function
`color.new <https://www.tradingview.com/study-script-reference/v4/#fun_color{dot}new>`__.

Here is an example of ``color.new`` usage::

    //@version=4
    study(title="Shading the chart's background", overlay=true)
    c = color.navy
    bgColor = (dayofweek == dayofweek.monday) ? color.new(c, 50) :
    (dayofweek == dayofweek.tuesday) ? color.new(c, 60) :
    (dayofweek == dayofweek.wednesday) ? color.new(c, 70) :
    (dayofweek == dayofweek.thursday) ? color.new(c, 80) :
    (dayofweek == dayofweek.friday) ? color.new(c, 90) :
    color.new(color.blue, 80)
    bgcolor(color=bgColor)


string
^^^^^^

String literals may be enclosed by single or double quotation marks, for
example::

    "This is a double quoted string literal"
    'This is a single quoted string literal'

Single or double quotation marks are completely the same --- you may use
what you prefer. The line that was written with double quotation marks
may contain a single quotation mark, just as a line that is written with
single quotation marks may contain double quotation marks::

    "It's an example"
    'The "Star" indicator'

If a user needs to put either double quotation marks in a line that is
enclosed by double quotation marks (or put single quotation marks in a
line that is enclosed by single quotation marks,) then they must be
preceded with backslash. For example::

    'It\'s an example'
    "The \"Star\" indicator"

There are all 5 forms of string type in Pine:

    * *literal string*
    * *const string*
    * *input string*
    * *string*
    * *series string*


line and label
^^^^^^^^^^^^^^

New drawing objects were introduced in Pine v4. These objects could be created with 
`line.new <https://www.tradingview.com/study-script-reference/v4/#fun_line{dot}new>`__ 
and `label.new <https://www.tradingview.com/study-script-reference/v4/#fun_label{dot}new>`__ 
functions. Their types are  *series line* and *series label* correspondingly.
There is only one series form of drawing types in Pine.


void
----

There is a *void* type in Pine Script. All the functions and annotation functions with *side effect* 
return void result. For example a 
`strategy.entry <https://www.tradingview.com/study-script-reference/v4/#fun_strategy{dot}entry>`__,
`plotshape <https://www.tradingview.com/study-script-reference/v4/#fun_plotshape>`__ etc.

Void result from function means that it cannot be used in any arithmetic expression or to be assigned to a variable.

na value
--------

In Pine there is a special built-in variable ``na``, which is an acronym for *not available*.
Such a value means that an expression or a variable has actually no value (or value is not avaiable). This is very similar
to ``null`` value in Java or ``None`` in Python.

There are a few things to know about ``na`` values. First, ``na`` value could be automatically casted to almost any type.

Second, in some cases Pine compiler cannot automatically infer type for ``na`` value, because more that one automatic type cast rules 
could be applied. For example::
    
    myVar = na // Compilation error!

Compiler cannot guess, would ``myVar`` be used to plot something, e.g. ``plot(myVar)`` (and thus it's type is *series float*), or to set some text
``label.set_text(lb, text=myVar)`` (meaning that it's type is *series string*) and so on. 
Such cases could be resolved in a two equivalent ways::
    
    float myVar = na

or::
    
    myVar = float(na)

Third, to test if some value is *not available* or not, a special function `na <https://www.tradingview.com/study-script-reference/v4/#fun_na>`__ should be used. Do not use operator ``==`` against ``na`` value.
This is not guaranteed to work.


Tuples
------

In Pine Script there is a limited support for tuple types. A tuple is a immutable sequence of values that could be returned as a function call result.
For example::

    calcSumAndMul(a, b) =>
        sum = a + b
        mul = a * b
        [sum, mul]

In this example there is a 2-tuple on the last statement of function ``calcSumAndMul``. Tuple elements could be of an arbitrary type. 
There is also a special syntax for calling functions that return tuples. For example ``calcSumAndMul`` could be called::

    [s, m] = calcSumAndMul(high, low)

Value of local variable ``sum`` will be written to ``s`` variable of the outer scope. So as ``mul`` value will be written to ``m`` variable.

Other
-----

A few function annotations (in particular ``plot`` and ``hline``) return
values which represent objects created on the chart. The function
``plot`` returns an object of the type *plot*, represented as a line
or diagram on the chart. The function ``hline`` returns an object of the
type *hline*, represented as a horizontal line. These objects can be
passed to the `fill <https://www.tradingview.com/study-script-reference/v4/#fun_fill>`__ 
function to color the area in between them.

Type casting
------------

There is an automatic type casting in Pine Script. 
In the following picture an arrow means ability to automatically cast one type to
another:

.. image:: images/Type_cast_rules_v4.svg
    :width: 1024px
    :height: 768px

For example::

    //@version=4
    study("My Script")
    plotshape(series=close)

Type of ``series`` parameter of ``plotshape`` function is *series bool*. But the function is called 
with ``close`` argument which type is *series float*. Types do not match, but there is
an automatic type cast rule *series float* |rarr| *series bool* (see the diagram) which does the conversion.


Sometimes there is no type conversion *X* |rarr| *Y*. That is why in Pine (since version 4) there are 
functions for explicit type casting. They are:
    
    * `int <https://www.tradingview.com/study-script-reference/v4/#fun_int>`__
    * `float <https://www.tradingview.com/study-script-reference/v4/#fun_float>`__
    * `string <https://www.tradingview.com/study-script-reference/v4/#fun_string>`__
    * `bool <https://www.tradingview.com/study-script-reference/v4/#fun_bool>`__
    * `color <https://www.tradingview.com/study-script-reference/v4/#fun_color>`__
    * `line <https://www.tradingview.com/study-script-reference/v4/#fun_line>`__
    * `label <https://www.tradingview.com/study-script-reference/v4/#fun_label>`__

Here is an example::

    //@version=4
    study("My Script")
    len = 10.0
    s = sma(close, len) // Compilation error!
    plot(s)
    
This code fails to compile with an error: **Add to Chart operation failed, reason: 
line 4: Cannot call `sma` with arguments (series[float], const float); available overloads: 
sma(series[float], integer) => series[float];**
Compiler says that type of ``len`` variable is *const float* but the ``sma`` function
expected ``integer``. There is no automatic type casting from *const float* to *integer*.
But an explicit type cast function could be used::

    //@version=4
    study("My Script")
    len = 10.0
    s = sma(close, int(len))
    plot(s)
