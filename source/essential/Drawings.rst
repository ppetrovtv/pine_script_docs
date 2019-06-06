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

Finally, here is a minimal code, that creates line objects on chart::

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

Being calculated on realtime bar updates script does not produce a new label object after every price movement. Rollback erases any drawing objects,
created during any intra-bar update. After calculation on a closing bar update a label object is finally commited and stays on chart.


Coordinates
-----------

Drawing objects are positioned on chart according to the *x* and *y* coordinates. Meaning (and the resulting effect) could be different, depending on
values of drawing properties *x-location* and *y-location*. Plus there are minor nuances for label and line.

If drawing object uses `xloc.bar_index <https://tvpm244.xstaging.tv/study-script-reference/v4/#var_xloc{dot}bar_index>`__, then
x-coordinate is treated as an absolute bar index. Bar index of the current bar could be obtained from built-in variable ``bar_index``. 
Bar index of the previous bars are ``bar_index[1]``, ``bar_index[2]`` and so on. ``xloc.bar_index`` is the default value for x-location parameters
of both label and line drawings.

If drawing object uses `xloc.bar_time <https://tvpm244.xstaging.tv/study-script-reference/v4/#var_xloc{dot}bar_time>`__, then
x-coordinate is treated as UNIX time in milliseconds. Start time of the current bar could be obtained from built-in variable ``time``.
Bar time of the previous bars are ``time[1]``, ``time[2]`` and so on. Time could be set as an absolute time point with the help of 
function `timestamp <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_timestamp>`__.

``xloc.bar_time`` mode gives an ability to place a drawing object in the future, in front of the current bar. For example::

    //@version=4
    study("My Script", overlay=true)
    dt = time - time[1]
    if barstate.islast
        label.new(time + 3*dt, close, xloc=xloc.bar_time)

.. image:: images/label_in_the_future.png

This code places a label object in the future. X-location logic works identically for both label and line drawings.

In contrast, y-location logic is different for label and line drawings.
For *line* drawings there is only one option here, they use `yloc.price <https://tvpm244.xstaging.tv/study-script-reference/v4/#var_yloc{dot}price>`__.
It means, that y-coordinate is treated as an absolute price value.

Label drawing has additional y-location values: `yloc.abovebar <https://tvpm244.xstaging.tv/study-script-reference/v4/#var_yloc{dot}abovebar>`__ and
`yloc.belowbar <https://tvpm244.xstaging.tv/study-script-reference/v4/#var_yloc{dot}belowbar>`__.
In this case, value of ``y`` parameter is ignored, because drawing object is placed on chart near the corresponding bar, above or below it.


Changing drawings
-----------------

Once a drawing object is created, it could be changed later. Functions ``label.new`` and ``line.new`` return 
a reference to the created drawing object (of type *series label* and *series line* respectively).
This reference then could be used as the first argument to functions ``label.set_*`` and ``line.set_*`` to modify the drawing. 
For example::

    //@version=4
    study("My Script", overlay=true)
    l = label.new(bar_index, na)
    if close >= open
        label.set_text(l, "green")
        label.set_color(l, color.green)
        label.set_yloc(l, yloc.belowbar)
        label.set_style(l, label.style_labelup)
    else
        label.set_text(l, "red")
        label.set_color(l, color.red)
        label.set_yloc(l, yloc.abovebar)
        label.set_style(l, label.style_labeldown)

.. image:: images/label_changing_example.png

This simple script creates a label on the current bar first and then it writes a reference to it in a variable ``l``. 
Then, depending on whether current bar is a rising or a falling bar (condition ``close >= open``), a number of label drawing properties are modified:
text, color, *y* coordinate location (``yloc``) and label style.

One may notice that ``na`` is passed as ``y`` argument to the ``label.new`` function call. The reason for this is that
label use either ``yloc.belowbar`` or ``yloc.abovebar`` y-locations. It means that label is bounded to the bar position on the chart. 
A finite value for ``y`` is needed only if label uses ``yloc.price`` as y-location value.

List of available *setter* functions for label drawing:

    * `label.set_color <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_color>`__ --- changes color of label
    * `label.set_size <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_size>`__ --- changes size of label
    * `label.set_style <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_style>`__ --- changes style of label
    * `label.set_text <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_text>`__ --- changes text of label
    * `label.set_textcolor <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_textcolor>`__ --- changes color of label text
    * `label.set_x <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_x>`__ --- changes x-coordinate of label
    * `label.set_y <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_y>`__ --- changes y-coordinate of label
    * `label.set_xy <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_xy>`__ --- changes both x and y coordinates of label at once
    * `label.set_xloc <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_xloc>`__ --- changes x-location of label
    * `label.set_yloc <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_label{dot}set_yloc>`__ --- changes y-location of label

List of available *setter* functions for line drawing:

    * `line.set_color <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_color>`__ --- changes color of line
    * `line.set_extend <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_extend>`__ --- changes attribute that makes a line segment, a ray or an endless line.
    * `line.set_style <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_style>`__ --- changes style of line (solid, dotted, dashed or with an arrow end)
    * `line.set_width <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_width>`__ --- changes width of line
    * `line.set_xloc <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_xloc>`__ --- changes x-location of line both ``x1`` and ``x2`` coordinates
    * `line.set_x1 <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_x1>`__ --- changes x1-coordinate of line
    * `line.set_y1 <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_y1>`__ --- changes y1-coordinate of line
    * `line.set_xy1 <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_xy1>`__ --- changes both x1 and y1 coordinates of line at once
    * `line.set_x2 <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_x2>`__ --- changes x2-coordinate of line
    * `line.set_y2 <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_y2>`__ --- changes y2-coordinate of line
    * `line.set_xy2 <https://tvpm244.xstaging.tv/study-script-reference/v4/#fun_line{dot}set_xy2>`__ --- changes both x2 and y2 coordinates of line at once


Label styles
------------

Script uses only two label styles: ``label.style_labelup`` and ``label.style_labeldown``. Other available styles are:

+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| Label style name               | Label                                           | Label with text                                 |
+================================+=================================================+=================================================+
| ``label.style_none``           |                                                 | |label_style_none_t|                            |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_xcross``         | |label_style_xcross|                            | |label_style_xcross_t|                          |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_cross``          | |label_style_cross|                             | |label_style_cross_t|                           |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_triangleup``     | |label_style_triangleup|                        | |label_style_triangleup_t|                      |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_triangledown``   | |label_style_triangledown|                      | |label_style_triangledown_t|                    |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_flag``           | |label_style_flag|                              | |label_style_flag_t|                            |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_circle``         | |label_style_circle|                            | |label_style_circle_t|                          |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_arrowup``        | |label_style_arrowup|                           | |label_style_arrowup_t|                         |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_arrowdown``      | |label_style_arrowdown|                         | |label_style_arrowdown_t|                       |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_labelup``        | |label_style_labelup|                           | |label_style_labelup_t|                         |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_labeldown``      | |label_style_labeldown|                         | |label_style_labeldown_t|                       |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_square``         | |label_style_square|                            | |label_style_square_t|                          |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+
| ``label.style_diamond``        | |label_style_diamond|                           | |label_style_diamond_t|                         |
+--------------------------------+-------------------------------------------------+-------------------------------------------------+

.. |label_style_xcross| image:: images/label.style_xcross.png
.. |label_style_cross| image:: images/label.style_cross.png
.. |label_style_triangleup| image:: images/label.style_triangleup.png
.. |label_style_triangledown| image:: images/label.style_triangledown.png
.. |label_style_flag| image:: images/label.style_flag.png
.. |label_style_circle| image:: images/label.style_circle.png
.. |label_style_arrowup| image:: images/label.style_arrowup.png
.. |label_style_arrowdown| image:: images/label.style_arrowdown.png
.. |label_style_labelup| image:: images/label.style_labelup.png
.. |label_style_labeldown| image:: images/label.style_labeldown.png
.. |label_style_square| image:: images/label.style_square.png
.. |label_style_diamond| image:: images/label.style_diamond.png

.. |label_style_none_t| image:: images/label.style_none_t.png
.. |label_style_xcross_t| image:: images/label.style_xcross_t.png
.. |label_style_cross_t| image:: images/label.style_cross_t.png
.. |label_style_triangleup_t| image:: images/label.style_triangleup_t.png
.. |label_style_triangledown_t| image:: images/label.style_triangledown_t.png
.. |label_style_flag_t| image:: images/label.style_flag_t.png
.. |label_style_circle_t| image:: images/label.style_circle_t.png
.. |label_style_arrowup_t| image:: images/label.style_arrowup_t.png
.. |label_style_arrowdown_t| image:: images/label.style_arrowdown_t.png
.. |label_style_labelup_t| image:: images/label.style_labelup_t.png
.. |label_style_labeldown_t| image:: images/label.style_labeldown_t.png
.. |label_style_square_t| image:: images/label.style_square_t.png
.. |label_style_diamond_t| image:: images/label.style_diamond_t.png


Line styles
-----------


Deleting drawings
-----------------

.. TODO how to delete old drawings
.. TODO limit of 50 drawing objects


Examples of classic indicators
------------------------------

Pivot points
^^^^^^^^^^^^

Zig Zag
^^^^^^^

Linear Regression
^^^^^^^^^^^^^^^^^

Tips and tricks
---------------

.. TODO max_bars_back(time, XXX)
.. TODO limitation: cannot create drawings on a secondary securities
.. TODO advantages of labels vs plotshapes



