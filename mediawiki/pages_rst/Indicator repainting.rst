.. raw:: mediawiki

   {{Languages}}

Historical data doesn’t include records of intra-bar movements of price.
This leads to a script working differently in historical data and in
real-time. We can see this difference, if we add a script on a chart,
wait till it compiles on a number of bars and then refresh the page.
This peculiarity is called **“Indicator repainting”**. There are a few
reasons for this.

We can see repainting in the following cases:

1. Strategies with parameter **calc\_on\_every\_tick**, set as **true**.
A strategy with parameter **calc\_on\_every\_tick = false** will be
prone to repainting too, (though to a lesser degree) as any strategy
depends on a starting point, which shifts to the future (once a week on
a minute resolution).

2. Using **security** for requesting data with greater resolution than
that of a chart: // Add this study on 1 minute chart //@version=3
study(“My Script”) c = security(tickerid, “5”, close, lookahead=false)
// 'lookahead=true' also causes the 'repainting problem' plot(close)
plot(c, color=red) Such a study will be calculated differently in
real-time and in historical data, regardless of using the parameter
lookahead (see `Understanding
lookahead <Context_Switching,_The_‘security’_Function#Understanding_lookahead>`__).

3. Using **security** for requesting data with resolution smaller than
on chart: // Add this study on 5 minute chart //@version=3 study(“My
Script”) c = security(tickerid, “1”, close, lookahead=false) plot(close)
plot(c, color=red)

-  in this scenario, a part of a minute-data will be inevitably lost, as
   it’s impossible to display it on a 5-minute chart and not to amplify
   the time axis
-  if lookahead=false - there will be repainting. When lookahead=true,
   no repainting would happen (there is an exception to this - when 1-
   and 5-minute updates outrun each other, a script can get repainted)

(Lookahead is the parameter which determines which 5-minute bar is shown
- the first or the last. See more `Understanding
lookahead <Context_Switching,_The_‘security’_Function#Understanding_lookahead>`__)

4. All the scripts which calculation results depend on a starting point.
Intraday data gets aligned to the beginning of the week, month or a
year, depending on the resolution. Due to this, the results produced by
such scripts can differ from time to time. Here are the examples of
scripts relying on the starting point:

-  `valuewhen <https://www.tradingview.com/study-script-reference/#fun_valuewhen>`__,
   `barssince <https://www.tradingview.com/study-script-reference/#fun_barssince>`__,
   `ema <https://www.tradingview.com/study-script-reference/#fun_ema>`__
   functions (peculiarities of the algorithm)
-  any backtesting strategy

There is the following dependency between a point of alignment and
resolution:

-  1-14 minutes - aligns to the beginning of a week
-  15-29 minutes - aligns to the beginning of a month
-  from 30 minutes and higher - to the beginning of a year

The following limitations of history length are taken into account when
processing the data:

-  10000 historical bars for all Pro plans
-  5000 historical bars for users without a Pro plan

5. Changes in historical data, for example, due to a split.

6. Presence of the following variables in the script:

-  barstate.isconfirmed, barstate.isfirst, barstate.ishistory,
   barstate.islast, barstate.isnew, barstate.isrealtime
-  timenow
-  n

--------------

Previous: `HOWTOs <HOWTOs>`__, Next: `Pine Compilation
Errors <Pine_Compilation_Errors>`__, Up: `Pine Script
Tutorial <Pine_Script_Tutorial>`__

`Category:Pine Script <Category:Pine_Script>`__
