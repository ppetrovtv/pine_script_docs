| If you want to choose the data source in the inputs pass it as a
  parameter of the function ``input``.
| You can choose any of the following as the default source:

-  open;
-  high;
-  low;
-  close;
-  hl2;
-  hlc3;
-  ohlc4.

Example 1. Simple

::

    study("My Script")
    src = input(close)
    plot(src)

Example 2. Extended

::

    study("My Script")
    src = input(title="Source", type=source, defval=close)
    plot(src)

--------------
