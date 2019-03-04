.. raw:: mediawiki

   {{Languages}}

There are additional functions that you may apply to ``tickerid``
function return value. They are ``heikinashi``, ``renko``,
``linebreak``, ``kagi`` and ``pointfigure``. All of them work in the
same manner, they just create a special ticker identifier that could be
passed later as ``security`` function first argument.

``heikinashi`` function
-----------------------

Heikin-Ashi means “average bar” in Japanese. Open, High, Low and Close
prices of HA candlesticks are not actual prices, they are results from
avergaing values of the previous bar, which helps eliminate random
volatility.

Pine function ``heikinashi`` creates a special ticker identifier for
requesting Heikin-Ashi data with ``security`` function.

This script requests low prices of Heikin-Ashi bars and plots them on
top of usual OHLC bars:

study(“Example 5”, overlay=true) ha\_t = heikinashi(tickerid) ha\_low =
security(ha\_t, period, low) plot(ha\_low)

.. figure:: Pine_Heikinashi.png
   :alt: Pine_Heikinashi.png

   Pine\_Heikinashi.png

Note that low prices of Heikin-Ashi bars are different from usual bars
low prices.

You may want to switch off extended hours data in “Example 5”. In this
case we should use ``tickerid`` function instead of ``tickerid``
variable:

study(“Example 6”, overlay=true) t = tickerid(syminfo.prefix, ticker,
session.regular) ha\_t = heikinashi(t) ha\_low = security(ha\_t, period,
low, true) plot(ha\_low, style=linebr)

Note that we pass additional fourth parameter to security (``true``),
and it means that points where data is absent, will not be filled up
with previous values. So we'd get empty areas during the extended hours.
To be able to see this on chart we also had to specify special plot
style (``style=linebr`` — Line With Breaks).

You may plot Heikin-Ashi bars exactly as they look from Pine script.
Here is the source code:

study(“Example 6.1”) ha\_t = heikinashi(tickerid) ha\_open =
security(ha\_t, period, open) ha\_high = security(ha\_t, period, high)
ha\_low = security(ha\_t, period, low) ha\_close = security(ha\_t,
period, close) palette = ha\_close >= ha\_open ? lime : red
plotcandle(ha\_open, ha\_high, ha\_low, ha\_close, color=palette)

.. figure:: Pine_Heikinashi_2.png
   :alt: Pine_Heikinashi_2.png

   Pine\_Heikinashi\_2.png

Read more about ‘plotcandle’ (and ‘plotbar’) functions
`here <https://www.tradingview.com/study-script-reference/#fun_plotcandle>`__.

``renko`` function
------------------

This chart type only plots price movements, without taking time or
volume into consideration. It is constructed from ticks and looks like
bricks stacked in adjacent columns. A new brick is drawn after the price
passes the top or bottom of previously predefined amount.

study(“Example 7”, overlay=true) renko\_t = renko(tickerid, “open”,
“ATR”, 10) renko\_low = security(renko\_t, period, low) plot(renko\_low)

.. figure:: Pine_Renko.png
   :alt: Pine_Renko.png

   Pine\_Renko.png

Please note that you cannot plot Renko bricks from Pine script exactly
as they look. You can just get a series of numbers that are somewhat
OHLC values for Renko chart and use them in your algorithms.

For detailed reference on all ``renko`` arguments go
`here <https://www.tradingview.com/study-script-reference/#fun_renko>`__.

``linebreak`` function
----------------------

This chart type displays a series of vertical boxes that are based on
price changes.

study(“Example 8”, overlay=true) lb\_t = linebreak(tickerid, “close”, 3)
lb\_close = security(lb\_t, period, close) plot(lb\_close)

.. figure:: Pine_Linebreak.png
   :alt: Pine_Linebreak.png

   Pine\_Linebreak.png

Please note that you cannot plot Line Break boxes from Pine script
exactly as they look. You can just get a series of numbers that are
somewhat OHLC values for Line Break chart and use them in your
algorithms.

For detailed reference on all ``linebreak`` arguments go
`here <https://www.tradingview.com/study-script-reference/#fun_linebreak>`__.

``kagi`` function
-----------------

This chart type looks like a continuous line that changes directions and
switches from thin to bold. The direction changes when the price changes
beyond a predefined amount, and the line switches between thin and bold
if the last change bypassed the last horizontal line.

study(“Example 9”, overlay=true) kagi\_t = kagi(tickerid, “close”, 1)
kagi\_close = security(kagi\_t, period, close) plot(kagi\_close)

.. figure:: Pine_Kagi.png
   :alt: Pine_Kagi.png

   Pine\_Kagi.png

Please note that you cannot plot Kagi lines from Pine script exactly as
they look. You can just get a series of numbers that are somewhat OHLC
values for Kagi chart and use them in your algorithms.

For detailed reference on all ``kagi`` arguments go
`here <https://www.tradingview.com/study-script-reference/#fun_kagi>`__.

``pointfigure`` function
------------------------

Point and Figure (PnF) chart type only plots price movements, without
taking time into consideration. A column of X’s is plotted as the price
rises — and O’s as the price drops.

Please note that you cannot plot PnF X's and O's from Pine script
exactly as they look. You can just get a series of numbers that are
somewhat OHLC values for PnF chart and use them in your algorithms.
Every column of X's or O's are represented with four numbers, you may
think of them as some imaginary OHLC PnF values. In Pine script you may
request and get those numbers and plot them on chart.

study(“Example 10”, overlay=true) pnf\_t = pointfigure(tickerid, “hl”,
“ATR”, 14, 3) pnf\_open = security(pnf\_t, period, open, true)
pnf\_close = security(pnf\_t, period, close, true) plot(pnf\_open,
color=lime, style=linebr, linewidth=4) plot(pnf\_close, color=red,
style=linebr, linewidth=4)

.. figure:: Pine_Point_and_Figure.png
   :alt: Pine_Point_and_Figure.png

   Pine\_Point\_and\_Figure.png

For detailed reference on all ``pointfigure`` arguments go
`here <https://www.tradingview.com/study-script-reference/#fun_pointfigure>`__.

--------------

Previous: `Extended and Regular
Sessions <Extended_and_Regular_Sessions>`__, Next:
`Annotation\_Functions\_Overview <Annotation_Functions_Overview>`__, Up:
`Pine Script Tutorial <Pine_Script_Tutorial>`__

`Category:Pine Script <Category:Pine_Script>`__
