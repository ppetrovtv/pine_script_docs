Shapes using 'plotshape', 'plotchar', 'plotarrow'
=================================================

.. contents:: :local:
    :depth: 2

In situations when you need to mark, highlight bars on a chart and not
draw a usual plot in the form of a line, the function ‘plot’ may not be
enough. Although it’s possible to execute this kind of task by applying
‘plot’ in combination with the styles ‘style=circles’ or ‘style=cross’,
it’s recommended to use the functions ‘plotshape’, ‘plotchar’,
‘plotarrow’.

The Function ‘plotshape’
------------------------

The function ‘plotshape’ is designed for displaying, under or above
bars, a few icon-shapes. For example, the script below will draw an ‘X’
above all green bars:

::

    study('plotshape example 1', overlay=true)
    data = close >= open
    plotshape(data, style=shape.xcross)

.. image:: images/Plotshape_1.png


The first parameter, ‘data’, is considered as a series of logical
values. The crosses are drawn on each true value and not on false values
or ‘na’ values. It’s possible to transfer a series of logical values in
‘plotshape’ to any series of numbers. It’s possible to transfer any
series of numbers to ‘plotshape’. A ‘0’ or ‘na’ is considered a false
value, any other value is considered true.

By changing the value of the parameter ‘style’ is possible to change the
form of the icon-shape. The available styles are:

+--------------------------+-------------------------------------------------+-------------------------------------------------+
| Shape Name               | Shape                                           | Shape with text                                 |
+==========================+=================================================+=================================================+
| ``shape.xcross``         | |Plotshape_xcross|                              | |Xcross_with_text|                              |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.cross``          | |Plotshape_cross|                               | |Cross_with_text|                               |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.circle``         | |Plotshape_circle|                              | |Circle_with_text|                              |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.triangleup``     | |Plotshape_triangleup|                          | |Triangleup_with_text|                          |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.triangledown``   | |Plotshape_triangledown|                        | |Triangledown_with_text|                        |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.flag``           | |Plotshape_flag|                                | |Flag_with_text|                                |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.arrowup``        | |Plotshape_arrowup|                             | |Arrowup_with_text|                             |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.arrowdown``      | |Plotshape_arrowdown|                           | |Arrowdown_with_text|                           |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.square``         | |Plotshape_square|                              | |Square_with_text|                              |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.diamond``        | |Plotshape_diamond|                             | |Diamond_with_text|                             |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.labelup``        | |Plotshape_labelup|                             | |Labelup_with_text|                             |
+--------------------------+-------------------------------------------------+-------------------------------------------------+
| ``shape.labeldown``      | |Plotshape_labeldown|                           | |Labeldown_with_text|                           |
+--------------------------+-------------------------------------------------+-------------------------------------------------+

.. |Plotshape_xcross| image:: images/Plotshape_xcross.png
.. |Xcross_with_text| image:: images/Xcross_with_text.png
.. |Plotshape_cross| image:: images/Plotshape_cross.png
.. |Cross_with_text| image:: images/Cross_with_text.png
.. |Plotshape_circle| image:: images/Plotshape_circle.png
.. |Circle_with_text| image:: images/Circle_with_text.png
.. |Plotshape_triangleup| image:: images/Plotshape_triangleup.png
.. |Triangleup_with_text| image:: images/Triangleup_with_text.png
.. |Plotshape_triangledown| image:: images/Plotshape_triangledown.png
.. |Triangledown_with_text| image:: images/Triangledown_with_text.png
.. |Plotshape_flag| image:: images/Plotshape_flag.png
.. |Flag_with_text| image:: images/Flag_with_text.png
.. |Plotshape_arrowup| image:: images/Plotshape_arrowup.png
.. |Arrowup_with_text| image:: images/Arrowup_with_text.png
.. |Plotshape_arrowdown| image:: images/Plotshape_arrowdown.png
.. |Arrowdown_with_text| image:: images/Arrowdown_with_text.png
.. |Plotshape_square| image:: images/Plotshape_square.png
.. |Square_with_text| image:: images/Square_with_text.png
.. |Plotshape_diamond| image:: images/Plotshape_diamond.png
.. |Diamond_with_text| image:: images/Diamond_with_text.png
.. |Plotshape_labelup| image:: images/Plotshape_labelup.png
.. |Labelup_with_text| image:: images/Labelup_with_text.png
.. |Plotshape_labeldown| image:: images/Plotshape_labeldown.png
.. |Labeldown_with_text| image:: images/Labeldown_with_text.png

The function ‘plotshape’ draws, by default, icons/shapes above bars.To
set another position for the shapes, it’s possible with the parameter
‘location’. For example, the following script draws a green arrow
‘shape.triangleup’ above green bars and a red arrow ‘shape.triangledown’
above red bars:

::

    study('plotshape example 2', overlay=true)
    data = close >= open
    plotshape(data, style=shape.triangleup,
              location=location.abovebar, color=green)
    plotshape(not data, style=shape.triangledown,
              location=location.belowbar, color=red)

.. image:: images/Plotshape_example_2.png


Possible values for the parameter ‘location’:

-  location.abovebar — above a bar
-  location.belowbar — below a bar
-  location.top — top of a chart
-  location.bottom — bottom of a chart
-  location.absolute — any set/specified point on a chart

The value ‘location.absolute’ should be applied when the shapes need to
be applied on the chart without being linked to the chart’s bars or
edges. A value of the first parameter of the function ‘plotshape’ is
used as a ‘y’ coordinate. As such, the shape is displayed on null values
and not only on the ‘na’ values.

The example ‘plotshape example 2’ also illustrates that the shapes’
color can be set by the parameter ‘color’, which can accept more than
constant values of color constants.

Similar to the parameter ‘color’ of the function ‘plot’, it’s possible
to transfer expressions which will calculate the icon-shapes’ color
depending on conditions. For example:

::

    study('plotshape example 3', overlay=true)
    data = close >= open
    plotshape(true, style=shape.flag, color=data ? green : red)

.. image:: images/Plotshape_example_3.png


In the given example, the first parameter of the function ‘plotshape’ is
equal to ‘true’ which means that the shape will be displayed on each
bar. The color will be set by the condition:
``color=data ? green : red``

The function ‘plotshape’ has other possibilities:

-  Set the name of a displayed series of data using the parameter
   ‘title’
-  Shift a series of shapes to the left/right using the parameter
   ‘offset’
-  Set the transparency of shapes by the parameter ‘transp’
-  Parameter ‘text’ to display some short text above/below the shape.
   You may use ‘\\n’ to separate text lines

Function ‘plotchar’
-------------------

Plotchar’s primary difference from ‘plotshape’ is in the way it assigns
icon-shapes. In plotchar, it is set through the inline parameter ‘char’,
allowing any encoding unicode symbol to be used (which are supported by
the in-use font). For example:

::

    study('plotchar example', overlay=true)
    data = close >= open
    plotchar(data, char='a')

.. image:: images/Plotchar_example_1.png


By default, the parameter char accepts the value ★ ('BLACK STAR',
U+2605). It’s possible to use any letters, digits or various symbols,
for example: ❤, ☀, €, ⚑, ❄, ◆, ⬆, ⬇.

Example of ‘snowflakes’ ❄:

::

    study('plotchar example', overlay=true)
    data = close >= open
    plotchar(data, char='❄')

.. image:: images/Plotchar_example_2.png


Like ‘plotshape’, the function ‘plotchar’ allows:

-  Set a shape’s color, with a constant or complex arithmetic expression
-  Set a shape’s location, the parameter ‘location’
-  Set the name of a displayed series of data using the parameter
   ‘title’
-  Shift a series of shapes left/right using the parameter ‘offset’
-  Set the transparency of shapes using the parameter ‘transp’
-  Parameter ‘text’ to display some short text above/below the shape.
   You may use ‘\\n’ to separate text lines

The Function ‘plotarrow’
------------------------

The function ‘plotarrow’ allows for up/down arrows to be displayed on
the chart. The arrows’ lengths are not the same on each bar and are
calculated by the script code (depending on the conditions calculated).

The first series parameter of the function ‘plotarrow’ is used to place
arrows on the chart, using the following logic:

-  If a value series on the current bar is greater than 0, then an up
   arrow will be drawn, the length of the arrow proportionally to an
   absolute value.
-  If a value series on the current bar is less than 0, then a down
   arrow will be drawn, the length of the arrow proportional to an
   absolute value.
-  If a value series on the current bar is equal to 0 or ‘na’ then the
   arrow is not displayed.

Here is a simple script that illustrates how ‘plotarrow’ function works:

::

    study("plotarrow example", overlay=true)
    codiff = close - open
    plotarrow(codiff, colorup=teal, colordown=orange, transp=40)

.. image:: images/Plotarrow_example_1.png


As you can see, the more absolute value of the difference ‘close - open’
the longer the arrow. If ‘close - open’ is greater than zero, then an up
arrow is rendered, otherwise (when ‘close - open’ is less than zero) we
have a down arrow.

For another example, it’s possible to take the indicator “Chaikin
Oscillator” from the standard scripts and display it as an overlay above
a series in the form of arrows using ‘plotarrow’ :

::

    study("Chaikin Oscillator Arrows", overlay=true)
    short = input(3,minval=1), long = input(10,minval=1)
    osc = ema(accdist, short) - ema(accdist, long)
    plotarrow(osc)

.. image:: images/Plotarrow_example_2.png


This screenshot shows the original “Chaikin Oscillator” alongside the
script for better understanding.

As was stated earlier, the high of the arrow is chosen proportionally to
the absolute value of the first series parameter of the function
‘plotarrow’. The maximum and minimum possible sizes for the arrows (in
pixels) are set by the parameters ‘minheight’ and ‘maxheight’
respectively.

Additionally, the function ‘plotarrow’ allows:

-  Set the name of a displayed series of data using the parameter
   ‘title’
-  Set the color of an up arrow, parameter using ‘colorup’
-  Set the color of a down arrow and parameter using ‘colordown’
-  Shift a series of arrows left/right using the parameter ‘offset’
-  Set the transparency of shapes with the parameter ‘transp’

It’s important to note that ‘colorup’ and ‘colordown’ should receive a
constant value of the type ‘color’. Using expressions for determining
color (as is done in plot, plotshape, plotchar) is not allowed.
