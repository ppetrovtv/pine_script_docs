Example of an Indicator in Pine
===============================

A program written in Pine is composed of functions and variables.
Functions contain instructions that describe required calculations and
variables that save the values used in the process of those
calculations. The source code line should not start with spaces (there
is an exception, see :ref:`syntax of a multiline
function <multi_line_functions>`).

A script should contain a ``study`` function which specifies the script
name and some other script properties. Script body contains functions
and variables necessary to calculate the result which will be rendered
as a chart with a ``plot`` (or some other function that *produces the output*) 
function call.

As a first example, we'll examine the implementation of the
`MACD <https://www.tradingview.com/wiki/MACD>`__ indicator:

.. code-block:: pine
    :linenos:

    //@version=3
    study("MACD")
    fast = 12, slow = 26
    fastMA = ema(close, fast)
    slowMA = ema(close, slow)
    macd = fastMA - slowMA
    signal = sma(macd, 9)
    plot(macd, color=blue)
    plot(signal, color=orange)


Line 1: ``//@version=3``
    It is a comment with a special directive that sets the version of Pine Script language to 3.
Line 2: ``study("MACD")``
    Sets the name of the indicator — "MACD".
Line 3: ``fast = 12, slow = 26``
    Defines two integer variables, ``fast`` and ``slow``.
Line 4: ``fastMA = ema(close, fast)``
    Defines the variable ``fastMA``, containing the result of the
    EMA calculation (Exponential Moving Average) with the length equal
    to ``fast`` (12) on ``close`` series (closing prices of bars).
Line 5: ``slowMA = ema(close, slow)``
    Defines the variable ``slowMA``, containing the result of the
    EMA calculation with the length equal to ``slow`` (26) from ``close``.
Line 6: ``macd = fastMA - slowMA``
    Defines the variable ``macd``, which is being calculated as a
    difference between two EMAs with different length inputs.
Line 7: ``signal = sma(macd, 9)``
    Defines the variable ``signal``, calculated as a smooth value of the
    variable ``macd`` by the SMA algorithm (Simple Moving Average) with
    length equal to 9.
Line 8: ``plot(macd, color=blue)``
    Calls the ``plot`` function, which would draw a chart based on the values
    saved in the variable ``macd`` (the color of the line is blue).
Line 9: ``plot(signal, color=orange)``
    Calls the ``plot`` function, which would draw a chart for the variable
    ``signal`` with an orange color.

After adding the indicator "MACD" to the chart we would see the
following:

.. image:: images/Macd_pine.png

Pine contains a variety of built-in functions for the most popular
algorithms (`SMA <https://www.tradingview.com/wiki/Moving_Average#Simple_Moving_Average_.28SMA.29>`__,
`EMA <https://www.tradingview.com/wiki/Moving_Average#Exponential_Moving_Average_.28EMA.29>`__,
`WMA <https://www.tradingview.com/wiki/Moving_Average#Weighted_Moving_Average_.28WMA.29>`__, etc.) as well as
making it possible to create your custom functions. You can find a
description of all available built-in functions
`here <https://www.tradingview.com/study-script-reference/>`__. In the
following sections the document will describe in full all the Pine
Script capabilities.
