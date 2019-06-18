study annotation
----------------

Every *indicator* [#strategy]_ script must contain one call of the 
`study <https://www.tradingview.com/study-script-reference/v4/#fun_study>`__ 
annotation function, which has the following signature:

.. code-block:: text

    study(title, shorttitle, overlay, precision)

The annotation determines the indicator's general properties.
Only the ``title`` parameter is mandatory. It defines the name of the
indicator. This name will be used in the *Indicators* dialogue.

``shorttitle`` is the short name of the indicator displayed on the
chart, if it must be different than the value of ``title``.

``overlay`` is a logical type of argument. If it is true then the study
will be added as an overlay on top of the main chart. If it is false
then it will be added on in separate pane. False is the default
setting.

``precision`` is the number of digits after the floating point for study
values. It must be a non negative integer. Precision 0 uses
special formatting rules for very large numbers such as volume
("5183" will be formatted as "5K"). The default ``precision`` value is 4.


.. rubric:: Footnotes

.. [#strategy] Pine also has a `strategy <https://www.tradingview.com/study-script-reference/v4/#fun_strategy>`__ 
   annotation function which is used to create a :doc:`backtesting strategy </essential/Strategies>` rather than an indicator (or study).
