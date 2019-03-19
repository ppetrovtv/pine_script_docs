.. _pine_script_release_notes:

Pine Script Release Notes
=========================

This page contains release notes of notable changes in Pine Script.
 
2017-05-17: compile-time constants
----------------------------------

Pine Script used to have 3 types of constants --- literal, non-literal and
serial. Now there’s one more, but let’s look at existing ones first.

Some functions (input, color) can only accept literals as certain
arguments. We realized that it could be more convenient, so we added a
new type of constants that can be calculated during compilation. In
addition to literals, they include mathematical expressions that use
other literals and constants.

Any type of Pine Script literal (integer, float, boolean, string) is the
most specific type while the serial type is the most general one. The
compilation-time constants take a spot between the literal and
non-literal types. All of the functions that accepted literal as an
argument will now accept compilation-time constants as well.

2017-04-26: input with options
------------------------------

Some built-in indicators have a setting that lets you choose several
options. The same is possible in Pine Script now.

.. _kwargs_syntax_for_all_builtin_functions:

2017-04-17: kwargs syntax for all builtin functions
---------------------------------------------------

Pinescript had different calls for annotation functions (study, plot,…)
and built-in functions (sma, security, …). Annotation functions used to
accept keyword arguments while built-in functions didn’t.

You are now able to call all built-in functions using keyword arguments.
This will be especially useful for the security function to specify the
lookahead argument but skip the gaps argument:

::

    security('TSLA', 'D', close, lookahead=barmerge.lookahead_off)

.. _pine_script_release_notes_v3:

2017-03-20: Pine Version 3
--------------------------

`Repainting <https://getsatisfaction.com/tradingview/topics/strategies-and-indicators-are-repainting>`__
and
`backtesting <https://getsatisfaction.com/tradingview/topics/backtesting-using-higher-time-frames-is-a-complete-lie>`__
issues have been reported for some time. These issues are not identical,
but they are interrelated. Version 3 aims to solve the backtesting
issue. Here’s a more detailed explanation.

Repainting issue
~~~~~~~~~~~~~~~~

There’s a substantial difference between historical and real-time data
that a PineScript indicator or strategy uses. The key difference --- a
historical bar does NOT contain information about price movements
between High and Low of a bar. Only a few PineScript language tools are
sensitive to this difference:

-  Security --- while requesting data of a larger timeframe than a current
   one .
-  barstate.isrealtime, barstate.ishistory, barstate.islast,
   barstate.isnew --- while using built-in variables
-  While using strategy combined with calc\_on\_every\_tick=true.
-  While using a built-in variable --- timenow, n (Doesn’t relate to the
   historical and real-time data difference, but still causes the
   “repainting” issue sometimes).

The “repainting” issue usually occurs when using tools above --- since an
indicator is calculated based on real-time data first. After reloading
the chart, an indicator is REcalculated based on data that becomes
historical, while still using the same time period. The appearance of
the indicator changes.

In this case, the “repainting” effect is not a bug --- it’s a result of
applying certain language tools with different calculation methods. This
needs to be understood and taken into consideration while using
PineScript.

Here is a basic example that describes this case:

::

    //@version=2
    study("My Script")
    a = barstate.isrealtime or barstate.islast ? close : na
    plot(a)

The above script is based on historical data and always returns na. It
can be plotted only on the last bar of both historical and real-time
data. After each chart reload (after pressing F5) the border that
divides historical data and real-time will be shifted, in accordance
with the current time period.

Backtesting issue
~~~~~~~~~~~~~~~~~

The second issue is a security function that allows you to get 'future'
data while doing calculations using historical data. For example:
``security(tickerid, "D", high)`` on historical data will show the daily
high price on the first hourly bar of the day. This can be used to
create an incorrect backtesting strategy:

::

    //@version=2
    strategy("Fake strategy", overlay=true)

    r = input("D", type=resolution)
    l = security(tickerid, r, low)
    h = security(tickerid, r, high)

    longCondition = low == l
    if (longCondition)
        strategy.entry("My Long Entry Id", strategy.long)

    shortCondition = high == h
    if (shortCondition)
        strategy.entry("My Short Entry Id", strategy.short)

However, we believe that this type of behavior of the security function
could be useful when it’s being used in indicators. For instance,
`ChrisMoody <https://www.tradingview.com/u/ChrisMoody/>`__ uses this
effect in a popular indicator called `CM\_Pivot
Points\_M-W-D-4H-1H\_Filtered <https://www.tradingview.com/script/kqKEuQpn-CM-Pivot-Points-M-W-D-4H-1H-Filtered/>`__
(over 3000 likes) that is used to create pivot lines. Some other
examples --- `Open Close Daily
Line <https://www.tradingview.com/script/qDvoNB8f-Open-Close-Daily-Line/>`__,
`Time Frame
Superimpose <https://www.tradingview.com/script/QCvh8Cyx-Time-Frame-Superimpose/>`__,
as well as the `GetSatisfaction
comment <https://getsatisfaction.com/tradingview/topics/strategies-and-indicators-are-repainting#reply_18341804>`__.
We decided that the old behavior will remain available only when it’s
expressly indicated.

By default, security function will NOT return future data. This type of
behavior will be available by default starting from the PineScript v3 in
order to maintain backward compatibility (``//@version=3``).

We also added a new parameter lookahead with two values:
`barmerge.lookahead\_off <https://www.tradingview.com/study-script-reference/#var_barmerge.lookahead_off>`__
and
`barmerge.lookahead\_on <https://www.tradingview.com/study-script-reference/#var_barmerge.lookahead_on>`__
to switch between the new and old behavior of the
`security <https://www.tradingview.com/study-script-reference/#fun_security>`__
function. Detailed description of this parameter can be found in pine
tutorial chapter on
`security <Context_Switching,_The_%E2%80%98security%E2%80%99_Function#Barmerge:_gaps_and_lookahead>`__

Changes of type system
~~~~~~~~~~~~~~~~~~~~~~

-  Self-referenced and forward-referenced variables are removed
-  No more math operations with booleans

See `Migration Guide <Pine_Version_3_Migration_Guide>`__ for more
details.
