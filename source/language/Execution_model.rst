Execution model
===============

.. contents:: :local:
    :depth: 2

Pine code is always executed against some OHLCV symbol data set. This is a data of chart main symbol on which a Pine study is added.
Any symbol data set has a finite number of bars. If user scrolls chart to the left (to see the most early bars), then a portion of bars
is loaded on the chart. Loading process stops when either there are no more bars on that particular symbol or chart gets about 10000 bars [#all_available_bars]_.
User may scroll the chart to the left until the very first bar available, this is the bar with index 0
(see `bar_index <https://www.tradingview.com/pine-script-reference/v4/#var_bar_index>`__).

Bars that are closed are the *historic bars*. If there is a trading session running and there were trades recently (withing a bar timeframe period),
then there is also a *current bar* on the chart that is updating in realtime. After a while, *current bar* closes becoming a historic bar and a new
current bar opens. In out of session hours all the chart bars are the historic ones (because there are no trades).

In general, Pine indicator is executed on all historic bars from left to right and then it is executed on every realtime
bar update of the current bar (if there are any).

Calculation on history
----------------------

Let's take as an example a simple script::

    //@version=4
    study("My Script", overlay=true)
    src = close
    a = sma(src, 5)
    b = sma(src, 50)
    c = cross(a, b)
    plot(a, color=color.blue)
    plot(b, color=color.black)
    plotshape(c, color=color.red)

In more detail, calculation of Pine indicator starts from the very first bar (which has index 0). Built-in variables ``open``, ``high``, ``low``, ``close``, ``volume``
and ``time`` get corresponding values from the bar and script calculates from the first statement to the last. This calculation produces study output
values (they are plot, plotshape, etc. values, drawing objects or strategy orders) for that particular time point, associated with the bar.
Then, in the same manner, the second bar (with index 1) is processed and so on until all the history bars will be processed.
Thus, Pine script is executed **one time per every history bar**:

.. image:: images/execution_model_calculation_on_history.png

Then, indicator switches to a special mode for processing realtime updates.

Calculation on realtime
-----------------------

Pine indicator calculation on realtime bar updates is slightly different from history calculation because of
the additional *commit* and *rollback* actions on script variables.

In realtime processing mode, Pine indicator is executed **one time per every bar update** plus there is a

    * variables rollback **before every intra-bar update**
    * variables commit **after every closing bar update**

During rollback all the script variables are set to their most recent commited values (or initial values, if there were no commits yet).
Variables commit is a finalization of variables' values on the current bar. Commit makes variable values immutable on that particular bar.
This happens only once per bar when the bar closes.

In more detail, suppose there is a current bar (the rightmost bar) with a close price equal to 1.11500:

.. image:: images/execution_model_calculation_on_realtime.png

With such a close price value, indicator calculates ``c = cross(a, b)`` to ``true``,
thus there is a red cross on the last bar on the chart (as shown on the screenshot).
Imagine that in a next moment close price would go down, so script is going to recalculate.
Before that all the variables are rollbacked to their last commited values and then the ``a`` variable would be
calculated to a smaller value, below the ``b`` value.
In such a case ``c = cross(a, b)`` would be calculated to ``false`` and red cross on the
current bar would be erased. Values of script variables on the current bar may change (rollbacked and calculated to another value)
many times until they will be calculated for the last time as a result of the closing bar update
(the next data update would create a new bar). Those values become a historic values, it is said that they are *commited* then.

Rollback and commit are very important, they give scripts an ability to be not dependent on the price moves withing a bar which in turn
reduces *repainting* problems.

Additional resources
--------------------

A number of built-in variables ``barstate.*`` provide information about the current type of bar update
(e.g. historical, realtime, intra-bar, closing update etc.), :doc:`/essential/Bar_states_Built-in_variables_barstate`.

Calculation of strategies is more complex than calculation of indicators, :doc:`/essential/Strategies`.

.. rubric:: Footnotes

.. [#all_available_bars] Upper limit for the total number of bars on chart is about 10000 for *Pro/Premium* users. *Free* users are able to
   see about 5000 bars.

