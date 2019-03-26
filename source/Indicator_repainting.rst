Indicator Repainting
====================

Historical data doesn't include records of intra-bar movements of price.
This leads to a script working differently on historical data and at
real-time. If we add a script on a chart,
wait till it calculates on some number of real-time bars and then reload the page, 
we can see this difference. This peculiarity is called *Indicator repainting*.
Not all indicators have an effect of repainting. In most cases it depends on whether or not 
some certain functions or language constructs are used in the code. This document reveals this question in detail.

We can see repainting in the following cases:

#. Strategies with parameter ``calc_on_every_tick`` set to ``true``.
   A strategy with parameter ``calc_on_every_tick = false`` will be
   prone to repainting too (though to a lesser degree) as any strategy
   depends on a starting point, more on this below.

#. Using ``security`` for requesting data with a resolution *higher* than the resolution of chart main symbol::

    // Add this study on 1 minute chart
    //@version=3
    study("My Script")
    c = security(tickerid, "5", close)
    plot(close)
    plot(c, color=red)

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

   * `valuewhen <https://www.tradingview.com/study-script-reference/#fun_valuewhen>`__,
     `barssince <https://www.tradingview.com/study-script-reference/#fun_barssince>`__,
     `ema <https://www.tradingview.com/study-script-reference/#fun_ema>`__
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

   * `barstate.isconfirmed <https://www.tradingview.com/study-script-reference/#var_barstate{dot}isconfirmed>`__,
     `barstate.isfirst <https://www.tradingview.com/study-script-reference/#var_barstate{dot}isfirst>`__, 
     `barstate.ishistory <https://www.tradingview.com/study-script-reference/#var_barstate{dot}ishistory>`__,
     `barstate.islast <https://www.tradingview.com/study-script-reference/#var_barstate{dot}islast>`__, 
     `barstate.isnew <https://www.tradingview.com/study-script-reference/#var_barstate{dot}isnew>`__, 
     `barstate.isrealtime <https://www.tradingview.com/study-script-reference/#var_barstate{dot}isrealtime>`__;
   * `timenow <https://www.tradingview.com/study-script-reference/#var_timenow>`__;
   * `n <https://www.tradingview.com/study-script-reference/#var_n>`__.
