You can set a different fill color on each bar with the fill() function.

Usage example:

::

    //@version=2
    study(title="Colored fill", overlay=true)
    p1 = plot(high)
    p2 = plot(low)
    fill(p1, p2, color = close>open ? green : red)

.. figure:: Colored_filling.png
   :alt: Colored_filling.png

   Colored\_filling.png

--------------

`Category:Pine Script <Category:Pine_Script>`__
