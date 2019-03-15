Sessions and Time Functions
===========================

.. contents:: :local:
    :depth: 2

Functions and the Variable ``time``
-----------------------------------

In Pine there are special means for working with trade sessions, time
and date. We will review a simple chart, IBM,30 on which has been
applied 2 scripts: “Bar date/time” and “Session bars”.

.. image:: images/Chart_time_1.png


Here is the initial code of the first script “Bar date/time”:

::

    study("Bar date/time")
    plot(time)

This illustrates the meaning of the variable time. The variable
```time`` <https://www.tradingview.com/study-script-reference/#var_time>`__
returns the date/time (timestamp) of each bar on the chart in UNIX
format. As can be seen from the screenshot, the value ``time`` on the
last bar is equal to 1397593800000. This value is the number of
milliseconds that have passed since 00:00:00 UTC, 1 January, 1970 and
corresponds to Tuesday, 15th of April, 2014 at 20:30:00 UTC. (There are
a lot of online convertors, for example
`OnlineConversion.com <http://www.onlineconversion.com/unix_time.htm>`__).
The chart’s time gauge in the screenshot shows the time of the last bar
as 2014-04-15 16:30 (in the exchange timezone, from here the difference
between this time and UTC is 4 hours).

The second script, “Session bars”:

::

    study("Session bars")
    t = time(period, "0930-1600")
    plot(na(t) ? 0 : 1)

This shows how the user can distinguish between session bars and bars
that get into extended hours by using the built-in function ``time`` and
not the variable ``time`` (the background behind these bars has been
colored over with grey). The function ``time`` returns the time of the
bar in milliseconds UNIX time or NaN value if the bar is located outside
the given trade session (09:30-16:00 in our example). ``time`` accepts
two arguments, the first is ‘resolution’, the bars of which are needed
to determine their timestamp, and the second — ‘session specification’,
which is a string that specifies the beginning and end of the trade
session (in the exchange timezone). The string “0930-1600” corresponds
to the trade session symbol IBM. Examples of trade session
configurations: “0000-0000” — a complete 24 hours with the session
beginning at midnight. “1700-1700” — a complete 24 hours with the
session beginning at 17:00. “0900-1600,1700-2000” — a session that
begins at 9:00 with a break at 16:00 until 17:00 and ending at 20:00
“2000-1630” — an overnight session that begins at 20:00 and ends at
16:30 the next day. “0930-1700:146” - a session that begins at 9:30 and
ends at 17:00 on Sundays (1), Wednesdays (4) and Fridays (6) (other days
of the week are days off).

Session specification, which is being passed to the function ``time``,
is not required to correspond with the real trade session of the symbol
on the chart. It’s possible to pass different “hypothetical” session
specifications which can be used to highlight those or (other?) bars in
a data series. It’s possible to transfer the different ‘hypothetical’
session specifications which can be used to highlight those or other
bars in a data series.

There is an overloaded function ``time`` that allows the user to skip
custom session specification. In this case, internally, it will use a
regular session specification of a symbol. For example, it’s possible to
highlight the beginning of each half-hour bar on a minute-based chart in
the following way:

::

    study("new 30 min bar")
    is_newbar(res) =>
        t = time(res)
        change(t) != 0 ? 1 : 0
    plot(is_newbar("30"))

.. image:: images/Chart_time_2.png


The function ``is_newbar`` similar to the previous example can be used
in many situations. For example, it’s essential to display on an
intraday chart the highs and lows which began at the market’s opening:

::

    //@version=3
    study("Opening high/low", overlay=true)

    highTimeFrame = input("D", type=resolution)
    sessSpec = input("0930-1600", type=session)

    is_newbar(res, sess) =>
        t = time(res, sess)
        na(t[1]) and not na(t) or t[1] < t

    newbar = is_newbar("1440", sessSpec)
    s1 = na
    s1 := newbar ? low : nz(s1[1])
    s2 = na
    s2 := newbar ? high : nz(s2[1])

    plot(s1, style=circles, linewidth=3, color=red)
    plot(s2, style=circles, linewidth=3, color=lime)

.. image:: images/Chart_time_3.png


Pay attention to the variables ``highTimeFrame`` and ``sessSpec``. They
have been declared in a special way with the variable of the functions
``input``. Further information about indicator's inputs can be found
here: `input
variables <http:////www.tradingview.com/study-script-reference/#fun_input>`__.

Session Format by example
-------------------------

-  ``24x7`` - is everyday session 00:00 - 00:00.
-  ``0000-0000:1234567`` - same as ``24x7``.
-  ``0000-0000:23456`` - same as ``0000-0000``, monday to friday session
   that starts every day at 00:00 and ends at 00:00 of the next day.
-  ``1700-1700`` - is an overnight session. Monday session starts at
   sunday, 17:00, and ends at monday, 17:00. Also, only on
   monday-friday.
-  ``1000-1001:26`` - is a weird session, that lasts only one minute on
   mondays, and one minute on fridays.

Built-in Variables for working with Time
----------------------------------------

Pine’s standard library has an assortment of built-in variables which
allow a bar’s time in the logic of an argument’s algorithm to be used in
scripts:

-  ``time`` — UNIX time of the current bar in milliseconds **(in UTC
   timezone)**.
-  ``year`` — Current bar year.
-  ``month`` — Current bar month.
-  ``weekofyear`` — Week number of current bar time.
-  ``dayofmonth`` — Date of current bar time.
-  ``dayofweek`` — Day of week for current bar time. You can use
   `sunday <https://www.tradingview.com/study-script-reference/#var_sunday>`__,
   `monday <https://www.tradingview.com/study-script-reference/#var_monday>`__,
   `tuesday <https://www.tradingview.com/study-script-reference/#var_tuesday>`__,
   `wednesday <https://www.tradingview.com/study-script-reference/#var_wednesday>`__,
   `thursday <https://www.tradingview.com/study-script-reference/#var_thursday>`__,
   `friday <https://www.tradingview.com/study-script-reference/#var_friday>`__
   and
   `saturday <https://www.tradingview.com/study-script-reference/#var_saturday>`__
   variables for comparisons.
-  ``hour`` — Current bar hour.
-  ``minute`` — Current bar minute.
-  ``second`` — Current bar second.

The following are also built-in functions:

-  ``year(x)`` — Returns year for provided UTC time.
-  ``month(x)`` — Returns month for provided UTC time.
-  ``weekofyear(x)`` — Returns week of year for provided UTC time.
-  ``dayofmonth(x)`` — Returns day of month for provided UTC time.
-  ``dayofweek(x)`` — Returns day of week for provided UTC time.
-  ``hour(x)`` — Returns hour for provided UTC time.
-  ``minute(x)`` — Returns minute for provided UTC time.
-  ``second(x)`` — Returns second for provided time.

All these variables and functions return **time in exchange time zone**,
except for the ``time`` variable which returns time in UTC timezone.
