Drawings
========

Since Pine version 4, it is possible to write indicators and strategies which
create *drawing objects* on chart. At the moment two kinds of 
drawings are supported, they are *label* and *line*:

.. image:: images/label_and_line_drawings.png

.. note:: On TradingView chart there is a whole set of *Drawing Tools*
  which are created and modified manually by user mouse actions. Though they look very similar to
  Pine drawing objects they are essentially different entities. 
  Drawing objects created from Pine code are unable to modify by mouse actions.

.. TODO How to create and modify drawings
.. TODO drawing objects calculation over OHLCV bar updates (rollback/commit concepts)
.. TODO how to delete old drawings
.. TODO limit of 50 drawing objects
.. TODO label locations: absolute vs above/below bars
.. TODO bar_index vs time for x coordinate, drawings in the future
.. TODO examples of classic indicators: pivot points HL and standard, zig zag, linear regression
.. TODO advantages of labels vs plotshapes
.. TODO max_bars_back(time, XXX)
.. TODO limitation: cannot create drawings on a secondary securities




