Bar states. Built-in variables 'barstate'
=========================================

A set of build-in ``barstate`` variables allows users to define a state
of the bar which calculations are being made for.

-  ``barstate.isfirst`` --- ``true`` if a current bar is the first in the
   range of bars, otherwise --- ``false``,
-  ``barstate.islast`` --- ``true`` if a current bar is the last in the
   range of bars, otherwise --- ``false``,
-  ``barstate.ishistory`` --- ``true`` if a current bar is a historical
   one, otherwise --- ``false``,
-  ``barstate.isrealtime`` --- ``true`` if a current bar is a real-time
   bar, otherwise --- ``false``,
-  ``barstate.isnew`` --- ``true`` if a current bar is a new bar,
   otherwise --- ``false``.

All historical bars are new bars. For bars updating in real-time a bar
is considered as a new bar only at opening tick of this bar.

Here's the example of the script with new variables:

::

    study("Example barstate", overlay = true)
    first = barstate.isfirst
    last = barstate.islast
    hist = barstate.ishistory
    rt = barstate.isrealtime
    new = barstate.isnew

    plotchar(close, color = first ? red : na, location = location.belowbar)
    plotchar(close, color = last ? blue : na, location = location.belowbar)
    plotchar(close, color = hist ? gray : na, char='h')
    bgcolor(color = new ? green : na)
    barcolor(color = rt ? black: na)

.. image:: images/Chart_barstate_1.jpg

The script draws red and blue symbols under the first and the last bars
accordingly and puts 'h' on the top of the historical bars; background
of the new bars will be highlighted green, and the real-time bars will
be colored black.
