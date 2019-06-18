Script inputs
-------------

`input <https://www.tradingview.com/study-script-reference/v4/#fun_input>`__ annotations 
make it possible to indicate which variables in the
indicator's code are *incoming*. Widgets will be generated for the
variables on the indicator's (properties/attributes) page in order to
change the values via a more convenient way than modifying the script's
source code. You can also specify the title of the input in the form of
a short text string. The title is meant to explain the purpose of the
input, and you can specify lowest and highest possible values for
numerical inputs.

When the document is written, in Pine there are the following types of
inputs:

-  bool,
-  integer,
-  float,
-  string,
-  symbol,
-  resolution,
-  session,
-  source.

The following examples show how to create, each input and what
its widgets look like.



Boolean input
::

    b = input(title="On/Off", type=input.bool, defval=true)
    plot(b ? open : na)

.. figure:: images/Inputs_of_indicator_1.png



Integer input
::

    i = input(title="Offset", type=input.integer, defval=7, minval=-10, maxval=10)
    plot(offset(close, i))

.. figure:: images/Inputs_of_indicator_2.png



Float input
::

    f = input(title="Angle", type=input.float, defval=-0.5, minval=-3.14, maxval=3.14, step=0.2)
    plot(sin(f) > 0 ? close : open)

.. figure:: images/Inputs_of_indicator_3.png



::

    sym = input(title="Symbol", type=input.symbol, defval="SPY")
    res = input(title="Resolution", type=input.resolution, defval="60")
    plot(close, color=color.red)
    plot(security(sym, res, close), color=color.green)

.. figure:: images/Inputs_of_indicator_4.png

   Symbol and resolution inputs


The symbol input widget has a built-in *symbol search* which is turned
on automatically when the ticker's first symbols are typed.


::

    s = input(title="Session", type=input.session, defval="24x7")
    plot(time(period, s))

.. figure:: images/Inputs_of_indicator_5.png

   Session input


::

    src = input(title="Source", type=input.source, defval=close)
    ma = sma(src, 9)
    plot(ma)

.. figure:: images/Inputs_of_indicator_6.png

   Source input
