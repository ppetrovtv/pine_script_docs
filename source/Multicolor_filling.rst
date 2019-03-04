You can set a different fill color on each bar with the fill() function.

Usage example:

::

    //@version=2
    study(title="Colored fill", overlay=true)
    p1 = plot(high)
    p2 = plot(low)
    fill(p1, p2, color = close>open ? green : red)

.. figure:: images/Colored_filling.png
   :alt: images/Colored_filling.png

   images/Colored\_filling.png
