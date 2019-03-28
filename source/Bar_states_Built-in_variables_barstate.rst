Bar states. Built-in variables ``barstate.*``
=============================================

A set of built-in ``barstate.*`` variables allows users to define a state
of the bar which calculations are being made for.

-  ``barstate.isfirst`` --- ``true`` if current bar is the first in the
   whole range of bars available, ``false`` otherwise.

-  ``barstate.islast`` --- ``true`` if current bar is the last in the
   whole range of bars available, ``false`` otherwise. This flag helps to detect *the last historical bar*.

-  ``barstate.ishistory`` --- ``true`` if a current data update is a historical bar update, ``false`` otherwise (thus it is real-time).

-  ``barstate.isrealtime`` --- ``true`` if current data update is a real-time bar update, 
   ``false`` otherwise (thus it is historical). Note that every real-time bar is also the *last* one.

-  ``barstate.isnew`` --- ``true`` if current data update is the first (opening) update of a new bar,
   ``false`` otherwise.

-  ``barstate.isconfirmed`` --- ``true`` if current data update is the last (closing) update of the current bar, 
   ``false`` otherwise. The next data update will be an opening update of a new bar [#isconfirmed]_.

All historical bars are *new* bars. That is because of the fact that the script receives them in a sequential order 
from the oldest to the newer ones. For bars that update in real-time a bar
is considered as a new bar only at the opening tick of this bar.

Here is an example of a script with ``barstate.*`` variables::

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
accordingly and puts 'h' on the top of the historical bars. Background
of the new bars will be highlighted green, and the real-time bars will
be colored black.

.. rubric:: Footnotes

.. [#isconfirmed] Variable ``barstate.isconfirmed`` returns the state of current chart symbol data only. 
   It does not take into account any secondary symbol data requested with the ``security`` function.

