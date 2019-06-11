Structure of the script
=======================

.. include:: <isonum.txt>

A script in Pine usually consists of 

* ``//@version=4`` A special directive in a comment, that specifies the Pine language version. 
  If ``@version`` directive is missing, version 1 will be used. It is strongly recommended always
  use the latest version available.
* `study <https://www.tradingview.com/study-script-reference/v4/#fun_study>`__ or a 
  `strategy <https://www.tradingview.com/study-script-reference/v4/#fun_strategy>`__ annotation call. Parameters of this call set script title and 
  some other global settings.
* series of statements which implement the algorithm. 
  Each statement usually is placed on a separate line. It's possible to place a
  few statements on one line, dividing them with a comma ``,``. The first
  statement on the line must be placed at the beginning, keeping in mind
  that spaces before the statement are not allowed (this has a direct
  relation to the syntax of multiple line functions). Statements are one
  of three kinds:

    -  :ref:`variable declarations <variable_declaration>`
    -  :doc:`function declarations <Declaring_functions>`
    -  :doc:`functions and annotations calls <Functions_and_annotations>`
  
* It is required that study has at least one function/annotation call which produces some output on the chart 
  (e.g. ``plot``, ``plotshape``, ``barcolor`` or ``line.new``, etc.)
  For a strategy it is required to have at least one ``strategy.*`` call, e.g. ``strategy.entry``.

  The simplest valid Pine study could be found in *Pine Editor* |rarr| *New* |rarr| *Blank indicator script*::
    
    //@version=4
    study("My Script")
    plot(close)

  Correspondingly, a simple valid Pine strategy is (from *Pine Editor* |rarr| *New* |rarr| *Blank strategy script*)::
    
    //@version=4
    strategy("My Strategy", overlay=true)

    longCondition = crossover(sma(close, 14), sma(close, 28))
    if (longCondition)
        strategy.entry("My Long Entry Id", strategy.long)

    shortCondition = crossunder(sma(close, 14), sma(close, 28))
    if (shortCondition)
        strategy.entry("My Short Entry Id", strategy.short)

