Bar states. Built-in variables barstate.*
=========================================

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

    //@version=4
    study("Bar States", overlay = true)
    first = barstate.isfirst
    last = barstate.islast

    hist = barstate.ishistory
    rt = barstate.isrealtime

    new = barstate.isnew
    conf = barstate.isconfirmed

    t = new ? "new" : conf ? "conf" : "intra-bar"
    t := t + (hist ? "\nhist" : rt ? "\nrt" : "")
    t := t + (first ? "\nfirst" : last ? "\nlast" : "")
    label.new(bar_index, na, yloc=yloc.abovebar, text=t, 
    color=hist ? color.green : color.red)

First, "Bar States" study is added on a yearly chart and screenshot is taken before any realtime update was received. This shows the *first* and the
*last* bars. And the fact that all of the bars are the *new* ones:

.. image:: images/barstates_history_only.png

Second, a realtime update is received. The picture slightly changes, the current bar is an *intra-bar* --- neither *new* nor *confirmed*.

.. image:: images/barstates_history_then_realtime.png

Finally there is a screenshot of the same symbol but 1 minute timeframe, after several realtime bars had closed. Closed realtime bars 
show the *confirmed* state.

.. image:: images/barstates_history_then_more_realtime.png

.. note:: None of the history bars have *confirmed* attribute. This might look weird and incorrect... and it is. 
  Hopefully this would be fixed in the future Pine versions.

.. rubric:: Footnotes

.. [#isconfirmed] Variable ``barstate.isconfirmed`` returns the state of current chart symbol data only. 
   It does not take into account any secondary symbol data requested with the ``security`` function.
