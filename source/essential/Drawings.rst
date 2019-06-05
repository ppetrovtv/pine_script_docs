Drawings
========

.. contents:: :local:
    :depth: 2

Since Pine version 4, it is possible to write indicators and strategies which
create *drawing objects* on chart. At the moment two kinds of 
drawings are supported, they are *label* and *line*:

.. image:: images/label_and_line_drawings.png

.. note:: On TradingView chart there is a whole set of *Drawing Tools*
  which are created and modified manually by user mouse actions. Though they look very similar to
  Pine drawing objects they are essentially different entities. 
  Drawing objects created from Pine code are unable to modify by mouse actions.

Lines and labels allow you to create more sophisticated indicators like pivot points support/resistance levels,
zig zag, various labels with dynamic text info, etc.

In contrast to indicator plots (plots are created with functions ``plot``, ``plotshape``, ``plotchar``), 
drawing objects could be created on historical bars as well as in the future (where there is no bars yet).

Creating drawings
-----------------

Drawing objects in Pine are created with functions `label.new <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}new>`__ 
and `line.new <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}new>`__. 
Each function has a number of various parameters, but only the coorinates are the mandatory ones.
For example, a minimal code, that creates a label on every bar::
    
    //@version=4
    study("My Script", overlay=true)
    label.new(bar_index, high)

.. image:: images/minimal_label.png

Label is created with parameters ``x=bar_index`` (which is the index of the current bar, 
`bar_index <https://tvpm244.xstaging.tv/study-script-reference/v4/#var_bar_index>`__) and ``y=high`` (high price of the current bar).
When a new bar opens, a new label is created on it. Label object, created on the previous closed bar stays on chart, 
until indicator deletes it with an explicit call of `label.delete <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}delete>`__ 
function or it would be automatically collected as an old garbage object after a while.

Here is a modified version of the same script that shows values of ``x`` and ``y`` coordinates of the created labels::

    //@version=4
    study("My Script", overlay=true)
    label.new(bar_index, high, style=label.style_none, 
              text="x=" + tostring(bar_index) + "\ny=" + tostring(high))

.. image:: images/minimal_label_with_x_y_coordinates.png

In this example labels are shown without a background coloring (because of parameter ``style=label.style_none``) but with a 
dynamically created text (``text="x=" + tostring(bar_index) + "\ny=" + tostring(high)``) that prints actual values of label coordinates.

Finally, here is a minimal code, that creates a line objects on chart::

    //@version=4
    study("My Script", overlay=true)
    line.new(x1=bar_index[1], y1=low[1], x2=bar_index, y2=high)

.. image:: images/minimal_line.png


Calculation of drawings on bar updates
--------------------------------------

Drawing objects are subject to both *commit* and *rollback* actions as well as any other Pine variables, :doc:`/language/Execution_model`.

That is why script::

    //@version=4
    study("My Script", overlay=true)
    label.new(bar_index, high)

Being calculated on realtime bar updates does not produce a new label object after every price movement.

To be continued...

.. TODO How to create and modify drawings
.. TODO how to delete old drawings
.. TODO limit of 50 drawing objects
.. TODO label locations: absolute vs above/below bars
.. TODO bar_index vs time for x coordinate, drawings in the future
.. TODO examples of classic indicators: pivot points HL and standard, zig zag, linear regression
.. TODO advantages of labels vs plotshapes
.. TODO max_bars_back(time, XXX)
.. TODO limitation: cannot create drawings on a secondary securities




