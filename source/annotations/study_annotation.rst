``study`` annotation
--------------------

Every *indicator* [#strategy]_ script must contain at least one call of the annotation function
`study <https://www.tradingview.com/study-script-reference/#fun_study>`__ which has the following signature:

.. code-block:: text

    study(title, shorttitle, overlay, precision)

The given function determines the characteristics of all indicators as a
whole. Only ``title`` is a necessary argument which sets the name of the
indicator. This name will be used in the *Indicators'* dialogue.

``shorttitle`` is the short name of an indicator displayed in the
chart's legend. If it has not been specified, then it will use the
``title`` value.

``overlay`` is a logical type of argument. If it is true then the study
will be added as an overlay on top of the main series. If it is false
then it will be added on a separate chart pane; false is the default
setting.

``precision`` is a number of digits after the floating point for study
values on the price axis. Must be a non negative integer. Precision 0
has special rules for formatting very large numbers (like volume, e.g.
"5183" will be formatted as "5K"). Default value is 4.


.. rubric:: Footnotes

.. [#strategy] There is also a similar `strategy <https://www.tradingview.com/study-script-reference/#fun_strategy>`__ 
   annotation which is used to create a :doc:`backtesting strategy </essential/Strategies>` rather than an indicator.