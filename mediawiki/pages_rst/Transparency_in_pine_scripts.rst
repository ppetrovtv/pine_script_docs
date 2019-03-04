| Color type variables now have an additional parameter to set default
  transparency. There are 2 ways to configure transparency level:
| 1. #FFA50040 – the last 2 digits stand for 64% transparency (in
  hexadecimal system) for orange color (in RGBA format)

::

    bgcolor (#FFA50040)

2. You can use the ‘color’ function to change transparency:

::

    color(red, 70)

::

    color(#FFA500, 80)

Example:

::

    //@version=2
    study(title="Shading the chart's background", overlay=true)
    c = navy
    bgColor = (dayofweek == monday) ? color(c, 50) :
      (dayofweek == tuesday) ? color(c, 60) :
      (dayofweek == wednesday) ? color(c, 70) :
      (dayofweek == thursday) ? color(c, 80) :
      (dayofweek == friday) ? color(c, 90) :
      color(blue, 80)
    bgcolor(color=bgColor)

You can control transparency in properties of a study on Style tab.
|Transparency settings|

.. |Transparency settings| image:: Transparency_settings.png

