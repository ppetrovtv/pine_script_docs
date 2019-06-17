Sessions and time functions
===========================

.. contents:: :local:
    :depth: 2

Functions and the variable time
-------------------------------

In Pine there are special means for working with trade sessions, time
and date. We will review a simple chart, IBM,30 on which has been
applied 2 scripts: "Bar date/time" and "Session bars".

.. image:: images/Chart_time_1.png


Here is the initial code of the first script "Bar date/time":

::

    //@version=4
    study("Bar date/time")
    plot(time)

This illustrates the meaning of the variable `time <https://www.tradingview.com/study-script-reference/v4/#var_time>`__, 
which returns the date/time (timestamp) of each bar start on the chart in `UNIX
format <https://en.wikipedia.org/wiki/Unix_time>`__ [#millis]_. 
As can be seen from the screenshot, the value ``time`` on the
last bar is equal to 1397593800000. This value is the number of
*milliseconds* that have passed since 00:00:00 UTC, 1 January, 1970 and
corresponds to Tuesday, 15th of April, 2014 at 20:30:00 UTC.
The chart's time gauge in the screenshot shows the time of the last bar
as 2014-04-15 16:30 (in the exchange timezone, from here the difference
between this time and UTC is 4 hours).

The second script, "Session bars"::

    //@version=4
    study("Session bars")
    t = time(timeframe.period, "0930-1600")
    plot(na(t) ? 0 : 1)

This shows how the user can distinguish between session bars and bars
that get into extended hours by using the built-in *function* 
`time <https://www.tradingview.com/study-script-reference/v4/#fun_time>`__ and
not the variable ``time`` (the background behind these bars has been
colored over with grey). The function ``time`` returns the time of the
bar start in milliseconds UNIX time or ``na`` value if the bar is located outside
the given trade session (09:30--16:00 in our example). ``time`` accepts
two arguments, the first is ``resolution``, the bars of which are needed
to determine their timestamp, and the second --- ``session`` (session specification),
which is a string that specifies the beginning and end of the trade
session (in the exchange timezone). The string "0930-1600" corresponds
to the trade session of IBM symbol. Examples of trade session
specifications: 

0000-0000
   a complete 24 hours with the session
   beginning at midnight. 

1700-1700
   a complete 24 hours with the
   session beginning at 17:00.

0900-1600,1700-2000
   a session that
   begins at 9:00 with a break at 16:00 until 17:00 and ending at 20:00.

2000-1630
   an overnight session that begins at 20:00 and ends at
   16:30 the next day.

0930-1700:146
   a session that begins at 9:30 and
   ends at 17:00 on Sundays (1), Wednesdays (4) and Fridays (6) (other days
   of the week are days off).

24x7
   is everyday session 00:00--00:00.

0000-0000:1234567
   same as "24x7", an everyday session 00:00--00:00.

0000-0000:23456
   same as "0000-0000", Monday to Friday session
   that starts every day at 00:00 and ends at 00:00 of the next day.

1700-1700
   is an *overnight session*. Monday session starts at
   Sunday, 17:00, and ends at Monday, 17:00. Also, only on
   Monday--Friday.

1000-1001:26
   is a weird session, that lasts only one minute on
   Mondays (2), and one minute on Fridays (6).

Session specification, which is being passed to the function ``time``,
is not required to correspond with the real trade session of the symbol
on the chart. It's possible to pass different "hypothetical" session
specifications which can be used to highlight some other bars of
a data series.

There is an overloaded function ``time`` that allows the user to skip
custom session specification. In this case, internally, it will use a
regular session specification of a symbol. For example, it's possible to
highlight the beginning of each half-hour bar on a minute-based chart in
the following way::

    //@version=4
    study("new 30 min bar")
    is_newbar(res) =>
        t = time(res)
        change(t) != 0 ? 1 : 0
    plot(is_newbar("30"))

.. image:: images/Chart_time_2.png


The function ``is_newbar`` is similar to the previous example and can be used
in many situations. For example, it's essential to display on an
intraday chart the highs and lows which began at the market's opening::

    //@version=4
    study("Opening high/low", overlay=true)

    highTimeFrame = input("D", type=input.resolution)
    sessSpec = input("0930-1600", type=input.session)

    is_newbar(res, sess) =>
        t = time(res, sess)
        na(t[1]) and not na(t) or t[1] < t

    newbar = is_newbar("1440", sessSpec)

    var float s1 = na
    var float s2 = na
    if newbar
        s1 := low
        s2 := high

    plot(s1, style=plot.style_circles, linewidth=3, color=color.red)
    plot(s2, style=plot.style_circles, linewidth=3, color=color.lime)

.. image:: images/Chart_time_3.png


Pay attention to the variables ``highTimeFrame`` and ``sessSpec``. They
have been declared in a special way with the help of the 
`input <http:////www.tradingview.com/study-script-reference/v4/#fun_input>`__ functions.


Built-in variables for working with time
----------------------------------------

Pine's standard library has an assortment of built-in variables and functions which
make it possible to use time in various cases of the script logic.

The most basic variables:

-  `time <https://www.tradingview.com/study-script-reference/v4/#var_time>`__ --- UNIX time of the *current bar start* in milliseconds, UTC timezone.
-  `timenow <https://www.tradingview.com/study-script-reference/v4/#var_timenow>`__ --- Current UNIX time in milliseconds, UTC timezone.
-  `syminfo.timezone <https://www.tradingview.com/study-script-reference/v4/#var_syminfo{dot}timezone>`__ --- Exchange timezone of the chart main symbol series.

Variables that give information about the current bar start time:

-  `year <https://www.tradingview.com/study-script-reference/v4/#var_year>`__ --- Current bar year.
-  `month <https://www.tradingview.com/study-script-reference/v4/#var_month>`__ --- Current bar month.
-  `weekofyear <https://www.tradingview.com/study-script-reference/v4/#var_weekofyear>`__ --- Week number of current bar.
-  `dayofmonth <https://www.tradingview.com/study-script-reference/v4/#var_dayofmonth>`__ --- Date of current bar.
-  `dayofweek <https://www.tradingview.com/study-script-reference/v4/#var_dayofweek>`__ --- Day of week for current bar. You can use
   ``sunday``, ``monday``, ``tuesday``, ``wednesday``, ``thursday``, ``friday`` and ``saturday`` variables for comparisons.
-  `hour <https://www.tradingview.com/study-script-reference/v4/#var_hour>`__ --- Hour of the current bar start time (in exchange timezone).
-  `minute <https://www.tradingview.com/study-script-reference/v4/#var_minute>`__ --- Minute of the current bar start time (in exchange timezone).
-  `second <https://www.tradingview.com/study-script-reference/v4/#var_second>`__ --- Second of the current bar start time (in exchange timezone).

Functions for UNIX time "construction":

-  `year(t) <https://www.tradingview.com/study-script-reference/v4/#fun_year>`__ --- Returns year for provided UTC time ``t``.
-  `month(t) <https://www.tradingview.com/study-script-reference/v4/#fun_month>`__ --- Returns month for provided UTC time ``t``.
-  `weekofyear(t) <https://www.tradingview.com/study-script-reference/v4/#fun_weekofyear>`__ --- Returns week of year for provided UTC time ``t``.
-  `dayofmonth(t) <https://www.tradingview.com/study-script-reference/v4/#fun_dayofmonth>`__ --- Returns day of month for provided UTC time ``t``.
-  `dayofweek(t) <https://www.tradingview.com/study-script-reference/v4/#fun_dayofweek>`__ --- Returns day of week for provided UTC time ``t``.
-  `hour(t) <https://www.tradingview.com/study-script-reference/v4/#fun_hour>`__ --- Returns hour for provided UTC time ``t``.
-  `minute(t) <https://www.tradingview.com/study-script-reference/v4/#fun_minute>`__ --- Returns minute for provided UTC time ``t``.
-  `second(t) <https://www.tradingview.com/study-script-reference/v4/#fun_second>`__ --- Returns second for provided UTC time ``t``.
-  `timestamp(year, month, day, hour, minute) <https://www.tradingview.com/study-script-reference/v4/#fun_timestamp>`__ --- 
   Returns UNIX time of specified date and time. Note, there is also an overloaded version with an additional ``timezone`` parameter.

All these variables and functions return time in **exchange time zone**,
except for the ``time`` and ``timenow`` variables which return time in **UTC timezone**.


.. rubric:: Footnotes

.. [#millis] UNIX time is measured in seconds. Pine Script uses UNIX time multiplied by 1000, so it's in millisecods.

