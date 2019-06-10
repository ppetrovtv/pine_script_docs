Expressions, declarations and statements
========================================

.. contents:: :local:
    :depth: 2

Expressions
-----------

An expression is a sequence where operators or function
calls are applied to operands (variables or values) to define the calculations
and actions required by the script. Expressions in Pine almost always
produce a result (exceptions are the functions
``study``, ``fill``, ``strategy.entry``, etc. They produce side effects and will be covered
later).

Here are some examples of simple expressions::

    (high + low + close)/3
    sma(high - low, 10) + sma(close, 20)

.. _variable_declaration:

Variable declaration
--------------------

Variables in Pine are declared with the help of the special symbol ``=`` and optional ``var`` keyword
in one of the following ways:

.. code-block:: text

    <identifier> = <expression>
    <type> <identifier> = <expression>
    var <identifier> = <expression>
    var <type> <identifier> = <expression>

``<identifier>`` is the name of the declared variable, see :doc:`Identifiers`.

``<type>`` can be one of the predefined keywords: ``float``, ``int``, ``bool``, ``color``, ``string``, ``line`` or ``label``.
However, in most cases, explicit type declaration is redundant because type is automatically inferred from the ``<expression>`` 
on the right of the ``=`` at compile time. It is strongly recommended to explicitly declare variable type only in case compiler 
cannot determine it automatically. For example::

    baseLine0 = na          // compile time error!
    float baseLine1 = na    // OK
    baseLine2 = float(na)   // OK

In the frist line of the example, the compiler cannot determine the type of the ``baseLine0`` variable because ``na`` is a generic value of no particular type. The declaration of the ``baseLine1`` variable is correct because its ``float`` type is declared explicitly.
The declaration of the ``baseLine2`` variable is also correct because its type can be derived from the expression ``float(na)``, which is an explicit cast of ``na`` value to ``float`` type. The declarations of ``baseLine1`` and ``baseLine2`` are equivalent, by the way.

The ``var`` keyword is a special modifier that instructs the compiler to *create and initialize the variable only once*. This behavior is very useful in cases where a variable's value must peresist through the successive bar iterations of the script. For example, suppose we'd like to count the number of green bars on the chart::

    //@version=4
    study("Green Bars Count")
    var count = 0
    isGreen = close >= open
    if isGreen
        count := count + 1
    plot(count)

.. image:: images/GreenBarsCount.png

Without the ``var`` modifier, variable ``count`` would be reset to zero (thus loosing it's value) every time a new bar update triggers script calculation.

.. note:: ``var`` keyword was introduced in Pine since version 4.

In Pine v3 the study "Green Bars Count" could be written without use of the ``var`` keyword::
    
    //@version=3
    study("Green Bars Count")
    count = 0                       // These two lines could be replaced in v4
    count := nz(count[1], count)    // with 'var count = 0'
    isGreen = close >= open
    if isGreen
        count := count + 1
    plot(count)

Which is less readable. Plus it could be less efficient too. Suppose that ``count`` variable is 
initialized with an expensive function call instead of ``0``.

Examples of simple variable declarations::
    
    src = close
    len = 10
    ma = sma(src, len) + high

Examples with type modifiers and var keyword::

    float f = 10            // NOTE: expression of an int type, but the variable is float
    i = int(close)          // NOTE: explicit cast of float expression close to int type
    r = round(close)        // NOTE: round() and int() are different... int() simply throws fractional part away
    var hl = high - low

Example, illustrating the effect of ``var`` keyword::
    
    // Creates a new label object on every bar:
    label lb = label.new(bar_index, close, title="Hello, World!")

    // Creates just one label object on the first history bar only:
    var label lb = label.new(bar_index, close, title="Hello, World!")


.. _variable_assignment:

Variable assignment
-------------------

Mutable variable is such a variable which can be given a new value. 
The operator ``:=`` must be used to give a new value to a variable. 
A variable must be declared before you can set a value for it
(declaration of variables has been described :ref:`above<variable_declaration>`).

Type of a variable is identified on the declaration step. A variable can
be given a value of expression only if both the expression and the
variable belong to the same type, otherwise it will give you a
compilation error.

Variable assignment example::

    //@version=4
    study("My Script")
    price = close
    if hl2 > price
        price := hl2
    plot(price)

We also use an :ref:`"if" statement <if_statement>` in this example.

.. note:: Operator ``:=`` and mutable variables concept were introduced in Pine since version 2.


.. _if_statement:

if statement
------------

``if`` statement defines what block of statements must be executed when
conditions of the expression are satisfied.

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
-  ``condition`` --- if the ``condition`` expression is true, the logic from the *then* block
   (``var_decl_then0``, ``var_decl_then1``, etc.) is used, if the
   ``condition`` is false, the logic from the *else* block 
   (``var_decl_else0``, ``var_decl_else1``, etc.) is used.
-  ``return_expression_then``, ``return_expression_else`` --- the last
   expression from the *then* block or from the *else* block will
   return the final value of the whole ``if`` statement. If declaration of the
   variable is in the end, its value will be the result.

.. note:: ``if`` statement was introduced in Pine since version 2.

The type of returning value of the ``if`` statement depends on
``return_expression_then`` and ``return_expression_else`` type (their types
must match, it is not possible to return an integer value from the *then* block,
while you have a string value in the *else* block).

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

It is possible to omit the *else* block. In this case, if the ``condition``
is false, an *empty* value (``na``, or ``false``, or ``""``) will be assigned to the
``var_declarationX`` variable.

Example::

    x = if close > open
        close
    // If current close > current open, then x = close.
    // Otherwise the x = na.

The blocks *then* and *else* are shifted by 4 spaces [#tabs]_. If statements can
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
side effect of the expression, for example in :doc:`strategy trading</essential/Strategies>`:

::

    if (crossover(source, lower))
        strategy.entry("BBandLE", strategy.long, stop=lower,                    
                       oca_name="BollingerBands",
                       oca_type=strategy.oca.cancel, comment="BBandLE")
    else
        strategy.cancel(id="BBandLE")

.. _for_statement:

for statement
-------------

``for`` statement allows to execute a number of instructions repeatedly.
General code form of the statement:

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

.. note:: ``for`` statement was introduced in Pine since version 2.

``for`` loop example:

::

    //@version=4
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

.. rubric:: Footnotes

.. [#tabs] On TradingView *Pine Editor* the **Tab** key produces 4 spaces automatically.
