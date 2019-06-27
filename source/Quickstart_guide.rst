Quickstart guide
================

A script written in Pine is composed of functions and variables.
Functions contain instructions that describe the required calculations.
Variables save the values used or created during those
calculations.

A script must contain a ``study`` or ``strategy`` annotation which defines the script's
name and other properties. The script's body contains the functions
and variables necessary to calculate results which will be rendered
on a chart with a ``plot`` function, or some other function that plots the script's output.

Example of a Pine script
------------------------

Let's look at the implementation of the
`MACD <https://www.tradingview.com/wiki/MACD>`__ indicator in Pine:

.. code-block:: pine

    //@version=4
    study("MACD")
    fast = 12, slow = 26
    fastMA = ema(close, fast)
    slowMA = ema(close, slow)
    macd = fastMA - slowMA
    signal = sma(macd, 9)
    plot(macd, color=color.blue)
    plot(signal, color=color.orange)


Line 1: ``//@version=4``
    This is a comment containing a compiler directive that tells the compiler the script will use version 4 of Pine.
Line 2: ``study("MACD")``
    Defines the name of the script that will appear on the chart as "MACD".
Line 3: ``fast = 12, slow = 26``
    Defines two integer variables: ``fast`` and ``slow``.
Line 4: ``fastMA = ema(close, fast)``
    Defines the variable ``fastMA``, containing the result of the
    EMA calculation (Exponential Moving Average) with a length equal
    to ``fast`` (12), on the ``close`` series, i.e., the closing price of bars.
Line 5: ``slowMA = ema(close, slow)``
    Defines the variable ``slowMA``, containing the result of the
    EMA calculation with a length equal to ``slow`` (26), from ``close``.
Line 6: ``macd = fastMA - slowMA``
    Defines the variable ``macd`` as the difference between the two EMAs.
Line 7: ``signal = sma(macd, 9)``
    Defines the variable ``signal`` as a smoothed value of
    ``macd`` using the SMA algorithm (Simple Moving Average) with
    a length of 9.
Line 8: ``plot(macd, color=color.blue)``
    Calls the ``plot`` function to output the variable ``macd`` using a blue line.
Line 9: ``plot(signal, color=color.orange)``
    Calls the ``plot`` function to output the variable ``signal`` using an orange line.

After adding the "MACD" script to the chart you will see the following:

.. image:: images/Macd_pine.png

Pine contains a variety of built-in functions for the most popular
algorithms (`SMA <https://www.tradingview.com/wiki/Moving_Average#Simple_Moving_Average_.28SMA.29>`__,
`EMA <https://www.tradingview.com/wiki/Moving_Average#Exponential_Moving_Average_.28EMA.29>`__,
`WMA <https://www.tradingview.com/wiki/Moving_Average#Weighted_Moving_Average_.28WMA.29>`__, etc.).
You can also define your custom functions. You will find a
description of all available built-in functions
`here <https://www.tradingview.com/pine-script-reference/v4/>`__.
