Custom OHLC bars and candles
============================

You may define your own custom bars and candles in Pine scripts. There
are functions
`plotbar <https://www.tradingview.com/study-script-reference/#fun_plotbar>`__
and
`plotcandle <https://www.tradingview.com/study-script-reference/#fun_plotcandle>`__
for that purpose. Here is a small example:

::

    study("Example 1")
    plotbar(open, high, low, close)

.. image:: images/Custom_ohlc_bars_and_candles_1.png

The script "Example 1" simply replicates bars of the current symbol.
Nothing outstanding. We can paint them with green and red colors:

::

    study("Example 2")
    palette = close >= open ? lime : red
    plotbar(open, high, low, close, color=palette)

.. image:: images/Custom_ohlc_bars_and_candles_2.png

The "Example 2" illustrates 'color' argument, which could be given
constant values as red, lime, "#FF9090", as well as expressions that
calculate color ('palette' variable) in runtime.

Function 'plotcandle' is similar to 'plotbar', it just plots candles
instead of bars and have optional argument 'wickcolor'.

Both 'plotbar' and 'plotcandle' need four series arguments that will be
used as bar/candle OHLC prices correspondingly. If for example one of
the OHLC variables at some bar have NaN value, then the whole bar is not
plotted. Example:

::

    study("Example 3")
    c = close > open ? na : close
    plotcandle(open, high, low, c)

.. image:: images/Custom_ohlc_bars_and_candles_3.png

Of course you may calculate OHLC values without using available 'open',
'high', 'low' and 'close' values. For example you can plot "smoothed"
candles:

::

    study("Example 4")
    len = input(9)
    smooth(x) =>
        sma(x, len)
    o = smooth(open)
    h = smooth(high)
    l = smooth(low)
    c = smooth(close)
    plotcandle(o, h, l, c)

.. image:: images/Custom_ohlc_bars_and_candles_4.png

You may get an interesting effect, if you plot OHLC values taken from
higher timeframe. Let's say you want to plot daily bars on 60 minute
chart:

::

    // NOTE: add this script on intraday chart
    study("Example 5")
    higherRes = input("D", type=resolution)
    is_newbar(res) =>
        t = time(res)
        change(t) != 0 ? 1 : 0
    o = security(tickerid, higherRes, open)
    h = security(tickerid, higherRes, high)
    l = security(tickerid, higherRes, low)
    c = security(tickerid, higherRes, close)
    plotbar(is_newbar(higherRes) ? o : na, h, l, c, color=c >= o ? lime : red)

.. image:: images/Custom_ohlc_bars_and_candles_5.png

Functions plotbar and
plotcandle also have 'title' argument, so user can distinguish them in
Styles tab of Format dialog.
