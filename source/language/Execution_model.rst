Execution model
===============

.. contents:: :local:
    :depth: 2

When a Pine script is loaded on a chart it executes once on each historical bar using the available OHLCV (open, high, low, close, volume) values for each bar. Once the script's execution reaches the rightmost bar in the dataset, if trading is currently active on the chart's symbol, then Pine *studies* will execute once every time price changes. Pine *strategies* will by default only execute when the rightmost bar closes, but they can also be configured to execute every time price changes, like studies do.

All symbol/resolution pairs have a dataset comprising a limited number of bars. When you scroll a chart to the left to see the dataset's earlier bars, the corresponding bars are loaded on the chart. The loading process stops when there are no more bars for that particular symbol/resolution pair or approximately 10000 bars have been loaded [#all_available_bars]_. You can scroll the chart to the left until the very first bar of the dataset which has an index value of 0
(see `bar_index <https://www.tradingview.com/pine-script-reference/v4/#var_bar_index>`__).

All bars in a dataset are *historical bars* except the rightmost one if a trading session is active. When trading is active in the rightmost bar, it is called the *realtime bar*. The realtime bar updates when a price change is detected. When the realtime bar closes it becomes a historical bar and a new realtime bar opens. All bars created outside of session hours are considered historicial bars since there are no trades then.

Calculation based on historical bars
------------------------------------

Let's take a simple script and follow its execution on historical bars::

    //@version=4
    study("My Script", overlay=true)
    src = close
    a = sma(src, 5)
    b = sma(src, 50)
    c = cross(a, b)
    plot(a, color=color.blue)
    plot(b, color=color.black)
    plotshape(c, color=color.red)

On historical bars, a script executes at the equivalent of the bar's close, when the OHLCV values are all known for that bar. Prior to execution of the script on a bar, the built-in variables such as ``open``, ``high``, ``low``, ``close``, ``volume`` and ``time`` are set to values corresponding to those from that bar. A script executes **once per historical bar**.

Our example script is first executed on the very first bar of the dataset at index 0. Each statement is executed using the values for the current bar. Accordingly, on the first bar of the dataset, the following statement::

    src = close

initializes the variable ``src`` with the ``close`` value for that first bar, and each of the next lines is executed in turn. Because the script only executes once for each historical bar, the ``close`` value will never change during the same iteration of a script on a historical bar.

The execution of each line in the script produces calculations which in turn generate the study's output values, which can then be plotted on the chart. Our example uses the ``plot`` and ``plotshape`` calls at the end of the script. In the case of a strategy, the outcome of the calculations can be used to plot values or dictate the orders to be placed.

After execution and plotting on the first bar, the script is executed on the dataset's second bar which has an index of 1. The process then repeats until all historical bars in the dataset are processed and the script reaches the rightmost bar on the chart.

.. image:: images/execution_model_calculation_on_history.png

Calculation based on realtime bars
----------------------------------

The behavior of a Pine script on the realtime bar is very different than on historical bars. Recall that the realtime bar is the rightmost bar on the chart when trading is active on the chart's symbol. Also recall that strategies can behave in two different ways in the realtime bar. By default they only execute when the realtime bar closes, but the ``calc_on_every_tick`` parameter of the ``strategy`` declaration statement can be set to true to modify the strategy's behavior so that it executes each time price updates in the realtime bar, as studies do. The behavior described here for studies will thus apply to strategies using ``calc_on_every_tick=true``.

The most important difference between execution of scripts on historical and realtime bars is that while they execute only once on historical bars, they execute every time a price update occurs during a realtime bar. This entails that built-in variables such as ``high``, ``low`` and ``close`` which never change on a historical, **can** change at each of a script's iteration in the realtime bar. Note that in the realtime bar, the ``close`` variable always represents the **current price**. Changes in the built-in variables used in the script's calculations will in turn induce changes in the results of those calculations. As a result, the same script may produce different results every time it executes during the realtime bar—a phenomenon referred to as *repainting*.

has important consequences, as the script produce results each time of a script's calculations will 


Pine indicator calculation on realtime bar updates is slightly different comapred to historical bars because of
the additional *commit* and *rollback* actions on script variables.

In realtime processing mode, Pine indicator is executed **once per bar update** plus there is a

    * variables rollback **before every intra-bar update**
    * variables commit **after every closing bar update**

All the script variables are set to their most recent commited values (or initial values, if there were no commits yet) during a rollback .
Variables commit is a finalization of variables' values on the current bar. Commit makes variable values immutable on that particular bar.
This happens only once per bar when the bar closes.

In more detail, imageine there is a current bar (the latest bar) with a close price equal to 1.11500:

.. image:: images/execution_model_calculation_on_realtime.png

With such a close price value, indicator calculates ``c = cross(a, b)`` to ``true``,
thus there is a red cross on the last bar on the chart (as shown on the screenshot).
Imagine that in the next moment close price would go down, so script is going to recalculate.
Before that, all the variables are rolled back to their last commited values and then ``a`` variable could be less than ``b`` variable.
In such a case ``c = cross(a, b)`` can become ``false`` and red cross on the
current bar would be erased. Values of script variables on the current bar may change (roll back and become another value)
many times until they will be calculated for the last time as a result of the closing bar update
(the next data update would create a new bar). Those values become historical values, it is said that they are *commited* then.

Rollback and commit are very important, they give scripts an ability to be independent from price moves within a bar which in turn
reduces *repainting* problems.

Additional resources
--------------------

A number of built-in variables ``barstate.*`` provide information about the current type of bar update
(e.g., historical, realtime, intra-bar, closing update etc.), :doc:`/essential/Bar_states_Built-in_variables_barstate`.

Calculation of strategies is more complex than calculation of indicators, :doc:`/essential/Strategies`.

.. rubric:: Footnotes

.. [#all_available_bars] The upper limit for the total number of historical bars is about 10000 for *Pro/Premium* users. *Free* users are able to see about 5000 bars.

