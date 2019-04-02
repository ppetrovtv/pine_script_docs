Literals
========

.. contents:: :local:
    :depth: 2

Fixed values assigned with immediate values (e.g., ``10``, ``3.14``, ``"value"``),
which may not be altered by the script, are called literals. Literals
can only be a type of integer, float, bool and string.

In Pine there are no literals which represent values of a
series type. Instead, there are built-in variables of a series type
(such as ``open``, ``high``, ``low``, ``close``, ``volume``, ``time``, 
``hl2``, ``hlc3``, ``ohlc4``). These variables are not literals.

Integer literals
----------------

Integral-valued literals can be presented only in the decimal system.
For example::

    1
    750
    94572
    100

Floating-point literals
-----------------------

Real literals in comparison with integral-valued literals contain a
delimiter (the symbol ``.``) and/or the symbol ``e`` (which means
"multiply by 10 to the power of X", where X is the number after the
symbol ``e``) or both. Examples::

    3.14159    // 3.14159
    6.02e23    // 6.02 * 10^23
    1.6e-19    // 1.6 * 10^-19
    3.0        // 3.0

The first number is the rounded number Pi (π), the second number is very
large, while the third is very small. The fourth number is simply the
number ``3`` as a floating point number.

.. note:: It's possible to use uppercase ``E`` instead of lowercase ``e``.

Boolean literals
----------------

There are only two literals for representing logical values::

    true    // true value
    false   // false value

String literals
---------------

String literals may be enclosed by single or double quotation marks, for
example::

    "This is a double quoted string literal"
    'This is a single quoted string literal'

Single or double quotation marks are completely the same --- you may use
what you prefer. The line that was written with double quotation marks
may contain a single quotation mark, just as a line that is written with
single quotation marks may contain double quotation marks::

    "It's an example"
    'The "Star" indicator'

If a user needs to put either double quotation marks in a line that is
enclosed by double quotation marks (or put single quotation marks in a
line that is enclosed by single quotation marks,) then they must be
preceded with backslash. For example::

    'It\'s an example'
    "The \"Star\" indicator"

Color literals
--------------

Color literals have the following format: ``#`` followed by 6 or 8
hexadecimal digits matching RGB or RGBA value. The first two digits
determine the value for the **red** color component, the second two --- for
**green**, and the third pair --- the value for the **blue** component. 
Each component value is a hexadecimal number between ``00`` and ``FF`` (0 and 255 in decimal).

Fourth pair of digits is optional. When set, it specifies the **alpha** (opacity) 
component which value is also between ``00`` (fully transparent) and ``FF`` (fully opaque).
Examples::

    #000000                // black color
    #FF0000                // red color
    #00FF00                // green color
    #0000FF                // blue color
    #FFFFFF                // white color
    #808080                // gray color
    #3ff7a0                // some custom color
    #FF000080              // 50% transparent red color
    #FF0000FF              // same as #00FF00, fully opaque red color
    #FF000000              // completely transparent color

.. note:: When using hexadecimal figures it's possible to use them in
   either upper or lowercase.

It is possible to change transparency of the color using built-in
function `color <https://www.tradingview.com/study-script-reference/#fun_color>`__.
Here is an example of ``color`` usage::

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

You can control transparency in properties of a study on *Style* tab:

.. image:: images/Transparency_settings.png
