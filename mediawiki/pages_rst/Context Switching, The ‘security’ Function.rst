\_\_TOC\_\_

The function ``security`` lets the user to request data from additional
symbols and resolutions, other than the ones to which the indicator is
applied.

Detailed Description
--------------------

We will assume that we are applying a script to the chart IBM,1. The
following script will display the ‘close’ of the IBM symbol but on a 15
resolution.

::

    study("Example security 1", overlay=true)
    ibm_15 = security("NYSE:IBM", "15", close)
    plot(ibm_15)

.. figure:: Chart_security_1.png
   :alt: Example security 1

   Example security 1

As seen from the ``security`` arguments
`description <https://www.tradingview.com/study-script-reference/#fun_security>`__,
the first argument is the name of the requested symbol. The second
argument is the required resolution, and the third one is an expression
which needs to be computed on the requested series.

The name of the symbol can be set using two variants: with a prefix that
shows the exchange (or data provider) or without it. For example:
“NYSE:IBM”, “BATS:IBM” or“IBM”. In the case of using the name of a
symbol without an exchange prefix, the exchange selected by default is
BATS. Current symbol name is assigned to ‘ticker’ and ‘tickerid’
built-in variables. The variable ‘ticker’ contains the value of the
symbol name without an exchange prefix, for example ‘MSFT’. The variable
‘tickerid’ is a symbol name with an exchange prefix, for example,
‘BATS:MSFT’, ‘NASDAQ:MSFT’. It’s recommended to use ‘tickerid’ to avoid
possible ambiguity in the indicator’s displayed values of data taken
from different exchanges. Fundamentals data could be requested with
security too, here you can find more info `Fundamentals
Data <Fundamentals_Data>`__.

The resolution (the second argument of the ``security`` function ) is
also set as a string. Any intraday resolution is set by specifying a
number of minutes. The lowest resolution is ‘minute’ which is set by the
literal “1”. It’s possible to request any number of minutes: “5”, “10”,
“21”, etc. ‘Hourly’ resolution is also set by minutes. For example, the
following lines signify an hour, two hours and four hours respectively:
“60”, “120”, “240”. A resolution with a value of 1 day is set by the
symbols “D” or “1D”. It’s possible to request any number of days: “2D”,
“3D”, etc. Weekly and monthly resolutions are set in a similar way: “W”,
“1W”, “2W”, …, “M”, “1M”, “2M”. “M” and “1M” are sorts of one month
resolution value. “W” and “1W” are the same weekly resolution value. The
third parameter of the security function can be any arithmetic
expression or a function call, which will be calculated in chosen series
context.

For example, with the ``security`` the user can view a minute chart and
display an SMA (or any other indicator) based on any other resolution
(i.e. daily, weekly, monthly).

::

    study(title="High Time Frame MA", overlay=true)
    src = close, len = 9
    out = sma(src, len)
    out1 = security(tickerid, 'D', out)
    plot(out1)

Or one can declare the variable

::

    spread = high - low

and calculate it in 1, 15 and 60 minutes:

::

    spread_1 = security(tickerid, '1', spread)
    spread_15 = security(tickerid, '15', spread)
    spread_60 = security(tickerid, '60', spread)

The function ``security``, as should be understood from the examples,
returns a series which is adapted correspondingly to the time scale of
the current chart's symbol. This result can be either shown directly on
the chart (i.e., with ``plot``), or be used in further calculations of
the indicator’s code. The indicator ‘Advance Decline Line’ of the
function ``security`` is a more difficult example:

::

    study(title = "Advance Decline Line", shorttitle="ADL")
    sym(s) => security(s, period, close)
    difference = (sym("INDEX:ADVN") - sym("INDEX:DECN"))/(sym("INDEX:UNCN") + 1)
    adline = cum(difference > 0 ? sqrt(difference) : -sqrt(-difference))
    plot(adline)

The script requests three securities at the same time. Results of the
requests are then added to an arithmetic formula. As a result, we have a
stock market indicator used by investors to measure the number of
individual stocks participating in an upward or downward trend (`read
more <http://en.wikipedia.org/wiki/Advance%E2%80%93decline_line>`__).

Pay attention to the fact that, out of convenience, the call
``security`` is “wrapped up” in the user function ``sym``. (just to
write a bit less of code).

``security`` function was designed to request data of a timeframe higher
than the current chart timeframe. For example, if you have a 1h chart,
you can request 4h, 1D, 1W (or any higher timeframe) and plot the
results. It’s not recommended to request lower timeframe, for example
15min data from 1h chart.

Barmerge: gaps and lookahead
----------------------------

There are two switches that define how requested data will be mapped to
current timeframe.

First one controls gaps. Default value is barmerge.gaps\_off, data is
merged continiously (without gaps). If barmerge.gaps\_on then data will
be merged possibly with gaps (na values).

Second one was added in `version
3 <Pine_Script:_Release_Notes#Pine_Version_3>`__. Parameter lookahead
have two possible values:
`barmerge.lookahead\_off <https://www.tradingview.com/study-script-reference/#var_barmerge.lookahead_off>`__
and
`barmerge.lookahead\_on <https://www.tradingview.com/study-script-reference/#var_barmerge.lookahead_on>`__
to switch between the new (version 3) and old behavior (version 2 and 1)
of the
`security <https://www.tradingview.com/study-script-reference/#fun_security>`__
function.

Here is an `example <https://www.tradingview.com/x/l0mYFmyD/>`__ that
shows the behavioral difference of the security function on a 5 min
chart:

::

    //@version=3
    study("My Script", overlay=true)
    a = security(tickerid, '60', low, lookahead=barmerge.lookahead_off)
    plot(a, color=red)
    b = security(tickerid, '60', low, lookahead=barmerge.lookahead_on)
    plot(b, color=lime)

.. figure:: V3.png
   :alt: V3.png

   V3.png

The green line on the chart is the Low price of an hourly bar that is
requested with lookahead on. It’s the old behavior of the security
function, implemented in PineScript v2. The green line based on
historical data is displayed at the price level of an hourly low right
after a new hourly bar is created (dotted blue vertical lines). The red
line is a Low price of an hourly bar that is requested with lookahead
off. In this case the requested Low price of an hourly historical bar
will be given only on the last minute bar of the requested hour, when an
hourly bar’s Low won’t return future data. The fuchsia dotted line
represents the beginning of real-time data. You can see that
``barmerge.lookahead_on`` and ``barmerge.lookahead_off`` based on
real-time data behaves the same way according to
``barmerge.lookahead_off``.

Understanding lookahead
~~~~~~~~~~~~~~~~~~~~~~~

There are many published scripts with the following lines:

::

    //@version=2
    //...
    a = security(tickerid, 'D', close[1]) // It's barmerge.lookahead_on, because version=2

The expression in security (``close[1]``) is a value of ``close`` of the
previous day, which is why the construction **doesn’t use future data**.

In v3 we can rewrite this in two ways.

``barmerge.lookahead_on`` OR ``barmerge.lookahead_off``. If you use
``barmerge.lookahead_on``, then it’s quite simple:

::

    //@version=3
    //...
    a = security(tickerid, 'D', close[1], lookahead=barmerge.lookahead_on)

Because original construction doesn't use data from future it is
possible to rewrite it using ``barmerge.lookahead_off``. If you use
``barmerge.lookahead_off``, the script becomes more complex, but gives
you an understanding of how the lookahead parameter works:

::

    //@version=3
    //...
    indexHighTF = barstate.isrealtime ? 1 : 0
    indexCurrTF = barstate.isrealtime ? 0 : 1
    a0 = security(tickerid, 'D', close[indexHighTF], lookahead=barmerge.lookahead_off)
    a = a0[indexCurrTF]

When an indicator is based on historical data (i.e.
``barstate.isrealtime`` equals ``false``), we take the current Close of
the daily resolution and shift the result of ``security`` one bar to the
right in the current resolution. When an indicator is calculated on
real-time data, we take the Close of the previous day without shifting
``security``.

--------------

Previous: `Lines Wrapping <Lines_Wrapping>`__, Next:
`Bar\_states.\_Built-in\_variables\_‘barstate’ <Bar_states._Built-in_variables_‘barstate’>`__,
Up: `Pine Script Tutorial <Pine_Script_Tutorial>`__
