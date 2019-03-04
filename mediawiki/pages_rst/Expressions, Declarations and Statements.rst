Expressions
-----------

An expression is a sequence of applying both operators and function
calls to operands (variables, values), which determines the calculations
and actions done by the script. Expressions in Pine almost always
produce a result (only annotation functions are an exception, such as
**study** or **fill**. They produce side effects and will be covered
later).

Here are some examples of simple expressions:

::

    (high + low + close)/3
    sma(high - low, 10) + sma(close, 20)

Variable Declarations
---------------------

Variables in Pine are declared with the help of the special symbol **=**
in the following way:

::

    <identifier> = <expression>

In place of will be the name of the declared variable. Examples of
Variable Declarations:

::

    src = close
    len = 10
    ma = sma(src, len) + high

Three variables were declared here: **src**, **len** and **ma**.
Identifiers **close** and **high** are built-in variables. The
identifier **sma** is a built-in function for calculating Simple `Moving
Average <Moving_Average>`__.

Variable Assignment
-------------------

Mutable variable is such a variable which can be given a new value.

The operator **:=** must be used to give a value to a variable. To use
this operator, a special attribute must be used in the first line of a
code: ``//@version=2``. This attribute identifies the version of Pine
Script. Mutable variables were introduced in version 2.

A variable must be declared before you can set a value for it
(declaration of variables has been described above).

Type of a variable is identified on the declaration step. A variable can
be given a value of expression only if both the expression and the
variable belong to the same type, otherwise it will give you a
compilation error.

Variable assignment example:

::

    //@version=2
    study("My Script")
    price = close
    if hl2 > price
        price := hl2
    plot(price)

We also use an `‘if’
statement <Expressions,_Declarations_and_Statements#‘if’_statement>`__
in this example.

Self Referencing Variables in version 2
---------------------------------------

*Note: self referencing variables and forward referencing variables was
removed in `version 3 <Pine_Script:_Release_Notes>`__.*

The ability to reference the previous values of declared variables in
expressions where they are declared (using the operator **[]**) is a
useful feature in Pine.These variables are called self referencing
variables. For Example:

::

    study("Fibonacci numbers")
    fib = na(fib[1]) or na(fib[2]) ? 1 : fib[1] + fib[2]
    plot(fib)

Note: For Version 3, this can be achieved using the syntax:

::

    study("Fibonacci numbers v3")
    fib = 0
    fib := na(fib[1]) or na(fib[2]) ? 1 : fib[1] + fib[2]
    plot(fib)

(See migration guide:
https://www.tradingview.com/wiki/Pine_Version_3_Migration_Guide#Self-referenced_variables_are_removed)
Expert tip: mod out the Fibonacci numbers by 1000 to generate a plot you
can actually see:

::

    study("Fibonacci numbers v3")
    fib = 0
    fib :=( na(fib[1]) or na(fib[2]) ? 1 : fib[1] + fib[2] ) % 1000
    plot(fib)

The variable **fib** is a series of Fibonacci numbers : 1, 1, 2, 3, 5,
8, 13, 21, … Where the first two numbers are equal to 1 and 1 and each
subsequent number is the sum of the last two. In the given example, the
built-in function **na** is used and returns **true** if the value of
its argument has still not been determined (is **NaN**). In the example
produced below, the values fib[1] and fib[2] have not been determined on
the first bar, while on the second bar fib[2] has not been determined.
Finally, on the third bar both of them are defined and can be added.
|Fib.png|

Footnote: Since the sequence of Fibonacci numbers grows rather fast, the
variable ‘fib’ very quickly overflows. As such, the user should apply
the given indicator on the monthly ‘M’ or yearly ‘Y’ resolution,
otherwise the value ‘n/a’ will be on the chart instead of Fibonacci
numbers.

Preventing NaN values, Functions na and nz
------------------------------------------

Self referencing variables allow for the accumulation of values during
the indicator’s calculation on the bars. However there is one point to
remember. For example, let's assume we want to count all the bars on the
chart with the following script:

::

    barNum = barNum[1] + 1

The self referencing variable ‘barNum’ refers to its own value on the
previous bar, meaning, when the indicator will be calculated on every
bar, the value barNum[1] will be equal to NaN. Therefore, on the first
bar barNum[1] will not be defined (NaN). Adding 1 to NaN, NaN will still
be the result. In total, the entire barNum series will be equal on every
bar to NaN. On next bar, barNum = NaN + 1 = NaN and so on. In total,
barNum will contain only NaN values.

In order to avoid similar problems, Pine has a built-in function **nz**.
This function takes an argument and if it is equal to NaN then it
returns 0, otherwise it returns the argument’s value. Afterwards, the
problem with the bars’ calculation is solved in the following way:

::

    barNum = nz(barNum[1]) + 1

There is an overloaded version of **nz** with two arguments which
returns the second argument if the first is equal to **NaN**. Further
information about ‘nz’ can be found
`here <https://www.tradingview.com/study-script-reference/#fun_nz>`__.

In addition, there is a simple function with one argument that returns a
logical result called **na**. This function makes it possible to check
if the argument is NaN or not. Check it out
`here <https://www.tradingview.com/study-script-reference/#fun_na>`__.

The difference between **na** and **nz**: **na** returns a Boolean value
(True / False), and is therefore useful in constructing logical
expressions (if na(x), ...). **nz** is a “filler”, as it fills NaN
values of a series with zeros (in the case of **nz(x)**) or with a
user-specified value (in the case of **nz(x, y)**). Note: the
double-argument version **nz(x, y)** is equivalent to the logical
construction **na(x) ? y : x**. (This is a ternary operation, which can
be read: “if **na(x)** then **y** else **x**.”)

Simple Moving Average without applying the Function ‘sma’
---------------------------------------------------------

While using self referencing variables, it’s possible to write the
equivalent of the built-in function **sma** which calculates the Simple
Moving Average.

::

    study("Custom Simple MA", overlay=true)
    src = close
    len = 9
    sum = nz(sum[1]) - nz(src[len]) + src
    plot(sum/len)

The variable ‘sum’ is a moving sum with one window that has a length
‘len’. On each bar the variable ‘sum’ is equal to its previous value,
then the leftmost value in a moving window is subtracted from ‘sum’ and
a new value, which entered the moving window (the rightmost), is added.
This is the algorithm optimized for vector languages, see `Moving
Average <Moving_Average>`__ for a detailed basic algorithm description.

Further, before the graph is rendered, the ‘sum’ is divided by the
window size ‘len’ and the indicator is displayed on the chart as the
Simple Moving Average.

Self referencing variables can also be used in functions written by the
user. This will be discussed later.

‘if’ statement
--------------

**If** statement defines what block of statements must be executed when
conditions of the expression are satisfied.

To have access to and use the **if** statement, one should specify the
version of Pine Script language in the very first line of code:
``//@version=2``

General code form:

::

    var_declarationX = if condition
        var_decl_then0
        var_decl_then1
        …
        var_decl_thenN
        return_expression_then
    else
        var_decl_else0
        var_decl_else1
        …
        var_decl_elseN
        return_expression_else

where:

-  var\_declarationX — this variable gets the value of the **if**
   statement
-  condition — if the condition is true, the logic from the block
   **then** (var\_decl\_then0, var\_decl\_then1, etc) is used, if the
   condition is false, the logic from the block ‘else’
   (var\_decl\_else0, var\_decl\_else1, etc) is used.
-  return\_expression\_then, return\_expression\_else — the last
   expression from the block **then** or from the block **else** will
   return the final value of the statement. If declaration of the
   variable is in the end, its value will be the result.

The type of returning value of the **if** statement depends on
return\_expression\_then and return\_expression\_else type (their types
must match: it is not possible to return an integer value from **then**,
while you have a string value in **else** block).

Example:

::

    // This code compiles
    x = if close > open
        close
    else
        open
    // This code doesn’t compile
    x = if close > open
        close
    else
        "open"

It is possible to omit the **else** block. In this case if the condition
is false, an “empty” value (na, or false, or “”) will be assigned to the
var\_declarationX variable.

Example:

::

    x = if close > open
        close
    // If current close > current open, then x = close.
    // Otherwise the x = na.

The blocks “then” and “else” are shifted by 4 spaces. If statements can
include each other, +4 spaces:

::

    x = if close > open
        b = if close > close[1]
            close
        else
            close[1]
        b
    else
        open

It is possible to ignore the resulting value of an if statement
(“var\_declarationX=“ can be omited). It may be useful if you need the
side effect of the expression, for example in strategy trading:

::

    if (crossover(source, lower))
        strategy.entry("BBandLE", strategy.long, stop=lower,                    
                       oca_name="BollingerBands",
                       oca_type=strategy.oca.cancel, comment="BBandLE")
    else
        strategy.cancel(id="BBandLE")

‘for’ statement
---------------

**for** statement allows to execute a number of instructions repeatedly.
To use **for** statements, a special attribute must be used in the first
line of a code: ``//@version=2``. This attribute identifies the version
of Pine Script. **for** statements were introduced in version 2.

General code form:

::

    var_declarationX = for counter = from_num to to_num [by step_num]
        var_decl0
        var_decl1
        …
        continue
        …
        break
        …
        var_declN
        return_expression

where:

-  counter - a variable, loop counter.
-  from\_num - start value of the counter.
-  to\_num - end value of the counter. When the counter becomes greater
   than to\_num (or less than to\_num in case from\_num > to\_num) the
   loop is broken.
-  step\_num - loop step. Can be omitted (in the case loop step = 1). If
   from\_num is greater than to\_num loop step will change direction
   automatically, no need to specify negative numbers.
-  var\_decl0, … var\_declN, return\_expression - body of the loop. It
   must be shifted by 4 spaces or 1 tab.
-  return\_expression - returning value. When a loop is finished or
   broken, the returning value is given to the var\_declarationX.
-  continue - a keyword. Can be used only in loops. It switches the loop
   to next iteration.
-  break - a keyword. Can be used only in loops. It breaks the loop.

Loop example:

::

    //@version=2
    study("My sma")
    my_sma(price, length) =>
        sum = price
        for i = 1 to length-1
            sum := sum + price[i]
        sum / length
    plot(my_sma(close,14))

Variable ‘sum’ is a `mutable variable <#Variable_Assignment>`__ and a
new value can be given to it by an operator **:=** in body of the loop.
Also note that we recommend to use a built-in function
`sma <https://www.tradingview.com/study-script-reference/#fun_sma>`__
for `Moving Average <Moving_Average>`__ as it calculates faster.

--------------

Previous: `Functions vs Annotation
Functions <Functions_vs_Annotation_Functions>`__, Next: `Declaring
Functions <Declaring_Functions>`__, Up: `Pine Script
Tutorial <Pine_Script_Tutorial>`__

`Category:Pine Script <Category:Pine_Script>`__

.. |Fib.png| image:: Fib.png

