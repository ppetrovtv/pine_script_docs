
Barcoloring a series with barcolor
----------------------------------

The annotation function `barcolor <https://www.tradingview.com/study-script-reference/v4/#fun_barcolor>`__ 
lets you specify a color for a bar
dependent on the fulfillment of a certain condition. The following
example script renders the *inside* and *outside* bars in different colors::

    //@version=4
    study("barcolor example", overlay=true)
    isUp() => close > open
    isDown() => close <= open
    isOutsideUp() => high > high[1] and low < low[1] and isUp()
    isOutsideDown() => high > high[1] and low < low[1] and isDown()
    isInside() => high < high[1] and low > low[1]
    barcolor(isInside() ? color.yellow : isOutsideUp() ? color.aqua : isOutsideDown() ? color.purple : na)

.. image:: images/Barcoloring_a_series_barcolor_1.png


As you can see, when passing the ``na`` value, the colors stay with the default
chart color.