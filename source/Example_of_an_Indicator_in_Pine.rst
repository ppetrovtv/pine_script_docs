A program written in Pine is composed of functions and variables.
Functions contain instructions that describe required calculations and
variables that save the values used in the process of those
calculations. The source code line should not start with spaces (there
is an exception, see “\ `syntax of a multiline
function <Declaring_Functions#Multi-line_Functions>`__\ ”).

A script should contain a **study** function which specifies the script
name and some other script properties. Script body contains functions
and variables necessary to calculate the result which will be rendered
as a chart with a **plot** function call.

As a first example, we’ll examine the implementation of the
`MACD <MACD>`__ indicator:

::

    study("MACD")
    fast = 12, slow = 26
    fastMA = ema(close, fast)
    slowMA = ema(close, slow)
    macd = fastMA - slowMA
    signal = sma(macd, 9)
    plot(macd, color=blue)
    plot(signal, color=orange)

study(“MACD”)
    Sets the name of the indicator — “MACD”
fast = 12, slow = 26
    Defines two integer variables, ‘fast’ and ‘slow’.
fastMA = ema(close, fast)
    Defines the variable fastMA, containing the result of the
    calculation EMA (Exponential Moving Average) with the length equal
    to ‘fast’ (12) on ’close’ series (closing prices of bars).
slowMA = ema(close, slow)
    Defines the variable slowMA, containing the result of the
    calculation EMA with the length equal to ‘slow’ (26) from ‘close’.
macd = fastMA - slowMA
    Defines the variable ‘macd’, which is being calculated as a
    difference between two EMA with different length inputs.
signal = sma(macd, 9)
    Defines the variable ‘signal’, calculated as a smooth value of the
    variable ‘macd’ by the algorithm SMA (Simple Moving Average) with
    length equal to 9
plot(macd, color=blue)
    Call function ‘plot’, which would draw a chart based on the values
    saved in the variable ‘macd’ (the color of the line is blue).
plot(signal, color=orange)
    Call function ‘plot’, which would draw a chart for the variable
    ‘signal’ with an orange color.

After adding the indicator “MACD” to the chart we would see the
following:

.. figure:: images/Macd_pine.png
   :alt: images/Macd_pine.png

   images/Macd\_pine.png

Pine contains a variety of built-in functions for the most popular
algorithms (`sma <Moving_Average#Simple_Moving_Average_(SMA)>`__,
`ema <Moving_Average#Exponential_Moving_Average_(EMA)>`__,
`wma <Moving_Average#Weighted_Moving_Average_(WMA)>`__, etc.) as well as
making it possible to create your custom functions. You can find a
description of all available built-in functions
`here <https://www.tradingview.com/study-script-reference/>`__. In the
following sections the document will describe in full all the Pine
Script capabilities.
