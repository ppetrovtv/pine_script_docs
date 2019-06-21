Indicator repainting
====================

Historical data does not include records of intra-bar movements of price;
only open, high, low and close (OHLC). This leads to a script sometimes 
working differently on historical data and in real-time, where only the open price
does not change and where price will typically move many times before the 
real-time bar's final high, low and close values are
known after the real-time bar closes.

If we add a script on a chart,
wait until it calculates on a number of real-time bars and then reload the page, 
we will sometimes see a script's plots change slightly. This behavior is one of a few
different types of behaviors commonly referred to as *Indicator repainting*. It is the
type of repainting we are concerned with here, and which we will refer to when using *repainting*.

Other types of behavior sometimes referred to as *repainting* include plotting with a
negative offset on past bars and using otherwise unavailable future information with
calls to the ``security`` function, without understanding that used improperly, they
may inadvertently introduce into script calculations future information 
that is not available in real-time.

Not all indicators are subject to the type of repainting we discuss here. 
In most cases it depends on whether or not certain functions or language 
constructs are used in the code. Please note that this repainting effect 
is not a bug; it's the result of the inherent difference between historic 
bars and real-time bar information on TradingView.

We can see repainting in the following cases:

#. Strategies with parameter ``calc_on_every_tick`` set to ``true``.
   A strategy with parameter ``calc_on_every_tick = false`` will be
   prone to repainting too (though to a lesser degree) as any strategy
   depends on a starting point, more on this below.

#. Using ``security`` for requesting data with a resolution *higher* than the resolution of chart main symbol::

    // Add this study on 1 minute chart
    //@version=4
    study("My Script")
    c = security(syminfo.tickerid, "5", close)
    plot(close)
    plot(c, color=color.red)

   Such a study will be calculated differently at real-time and on
   historical data, regardless of using the parameter ``lookahead`` (see
   :ref:`understanding_lookahead`).

#. Using ``security`` for requesting data with resolution *lower* than the resolution of chart main symbol 
   (this case in more detail :ref:`here <requesting_data_of_a_lower_timeframe>`).
   if ``lookahead=false``, there will be repainting. When ``lookahead=true``,
   repainting is less possible. It still could happen, when 1 and 5 minute updates 
   outrun each other.

#. All the scripts which calculation results depend on a *starting point*.
   Intraday data gets aligned to the beginning of the week, month or a
   year, depending on the resolution. Due to this, the results produced by
   such scripts can differ from time to time. Here are the examples of
   scripts relying on the starting point:

   * `valuewhen <https://www.tradingview.com/study-script-reference/v4/#fun_valuewhen>`__,
     `barssince <https://www.tradingview.com/study-script-reference/v4/#fun_barssince>`__,
     `ema <https://www.tradingview.com/study-script-reference/v4/#fun_ema>`__
     functions (peculiarities of the algorithm).
   * any backtesting strategy (regardless of parameter ``calc_on_every_tick``).

   There is a dependency between the alignment of a starting point and
   resolution:

   * 1--14 minutes --- aligns to the beginning of a week.
   * 15--29 minutes --- aligns to the beginning of a month.
   * from 30 minutes and higher --- to the beginning of a year.

   The following limitations of history length are taken into account when
   processing the data:

   * 10000 historical bars for all Pro plans.
   * 5000 historical bars for users without a Pro plan.

#. Changes in historical data, for example, due to a *split*.

#. Presence of the following variables in the script usually leads to repainting:

   * `barstate.isconfirmed <https://www.tradingview.com/study-script-reference/v4/#var_barstate{dot}isconfirmed>`__,
     `barstate.isfirst <https://www.tradingview.com/study-script-reference/v4/#var_barstate{dot}isfirst>`__, 
     `barstate.ishistory <https://www.tradingview.com/study-script-reference/v4/#var_barstate{dot}ishistory>`__,
     `barstate.islast <https://www.tradingview.com/study-script-reference/v4/#var_barstate{dot}islast>`__, 
     `barstate.isnew <https://www.tradingview.com/study-script-reference/v4/#var_barstate{dot}isnew>`__, 
     `barstate.isrealtime <https://www.tradingview.com/study-script-reference/v4/#var_barstate{dot}isrealtime>`__;
   * `timenow <https://www.tradingview.com/study-script-reference/v4/#var_timenow>`__;
   * `bar_index <https://www.tradingview.com/study-script-reference/v4/#var_bar_index>`__.

The "repainting" issue usually occurs when using tools above --- since an
indicator is calculated based on real-time data first. After reloading
the chart, an indicator is REcalculated using the data that had become
a historical data, while still using the same time period. The appearance of
the indicator changes.

In this case, the "repainting" effect is not a bug --- it's a result of
applying certain language tools with different calculation methods. This
needs to be understood and taken into consideration while using
Pine Script.
