Release notes
=============

.. contents:: :local:
    :depth: 2

This page contains release notes of notable changes in Pine Script v4.

May 2020
--------------------------
The behavior of ``security`` function has changed:

* the ``expression`` parameter can be series or tuple 


April 2020
--------------------------
New function was added:

* ``quandl`` - request quandl data for a symbol

The behavior of ``security`` function has changed:

* the ``expression`` parameter can be series or tuple 


March 2020
--------------------------

New function was added:

* ``fianancial`` - request financial data for a symbol


New functions for common indicators were added:

* ``cmo`` - Chande Momentum Oscillator
* ``mfi`` - Money Flow Index
* ``bb`` - Bollinger Bands
* ``bbw`` - Bollinger Bands Width
* ``kc`` - Keltner Channels
* ``kcw`` - Keltner Channels Width 
* ``dmi`` - DMI/ADX
* ``wpr`` - Williams % R 
* ``hma`` - Hull Moving Average
* ``supertrend`` - SuperTrend


Added a detailed description of all the fields in the `Strategy Tester Report <https://www.tradingview.com/chart/?solution=43000561856/>`__


February 2020
--------------------------

* New Pine indicator VWAP Anchored was added. Now you can specify the time period: Session, Month, Week, Year.

* Fixed a problem with calculating ``percentrank`` function. Now it can return a zero value, which did not happen before due to an incorrect calculation.

* The default ``transparency`` parameter for the ``plot``, ``plotshape``, and ``plotchar`` functions is now 0%.

* For the functions ``plot``, ``plotshape``, ``plotchar``, ``plotbar``, ``plotcandle``, ``plotarrow``, you can set the ``display`` parameter, which controls the display of the plot. The following values can be assigned to it:

  * ``display.none`` - the plot is not displayed
  * ``display.all`` - the plot is displayed (Default)

* The ``textalign`` argument was added to the ``label.new`` function along with the ``label.set_textalign`` function. Using those, you can control the alignment of the label's text::

    //@version=4
    study("My Script", overlay = true)
    var l = label.new(bar_index, high, text="Right\n aligned\n text", textalign=text.align_right)
    label.set_xy(l, bar_index, high)

  .. image:: images/Label_text_align.png


January 2020
--------------------------
  
New built-in variables were added:


* ``iii`` - Intraday Intensity Index
* ``wvad`` - Williams Variable Accumulation/Distribution
* ``wad`` - Williams Accumulation/Distribution
* ``obv`` - On Balance Volume
* ``pvt`` - Price-Volume Trend
* ``nvi`` - Negative Volume Index 
* ``pvi`` - Positive Volume Index
   
New parameters were added for ``strategy.close``:


* ``qty`` -  the number of contracts/shares/lots/units to exit a trade with
* ``qty_percent`` - defines the percentage of entered contracts/shares/lots/units to exit a trade with
* ``comment`` - addtional notes on the order
    
New parameter was added for ``strategy.close_all``:


* ``comment`` - additional notes on the order

December 2019
--------------------------
* Warning messages were added.

  For example, if you don't specify exit parameters for ``strategy.exit`` - ``profit``, ``limit``, ``loss``, ``stop`` or one of the following pairs: ``trail_offset`` and ``trail_price`` / ``trail_points`` - you will see a warning message in the console in the Pine editor.
* Increased the maximum number of arguments in ``max``, ``min``, ``avg`` functions. Now you can use up to ten arguments in these functions.  

October 2019
--------------------------
* ``plotchar`` function now supports most of the Unicode symbols::

    //@version=4
    study("My Script", overlay=true)
    plotchar(open > close, char="🐻")


  .. image:: images/Bears_in_plotchar.png

* New ``bordercolor`` argument of the ``plotcandle`` function allows you to change the color of candles' borders::

    //@version=4
    study("My Script")
    plotcandle(open, high, low, close, title='Title', color = open < close ? color.green : color.red, wickcolor=color.black, bordercolor=color.orange)

* New variables added:
  
  * ``syminfo.description`` - returns a description of the current symbol
  * ``syminfo.currency`` - returns the currency code of the current symbol (EUR, USD, etc.)
  * ``syminfo.type`` - returns the type of the current symbol (stock, futures, index, etc.)

September 2019
--------------------------


New parameters to the ``strategy`` function were added:

* ``process_orders_on_close`` allows the broker emulator to try to execute orders after calculating the strategy at the bar's close

* ``close_entries_rule`` allows to define the sequence used for closing positions

Some fixes were made:

* ``fill`` function now works correctly with ``na`` as the ``color`` parameter value

* ``sign`` function now calculates correctly for literals and constants

``str.replace_all (source, target, replacement)`` function was added. It replaces each occurrence of a ``target`` string in the ``source`` string with a ``replacement`` string

July-August 2019
--------------------------


New variables added: 


* ``timeframe.isseconds`` returns true when current resolution is in seconds
    
* ``timeframe.isminutes`` returns true when current resolution is in minutes
    
* ``time_close`` returns the current bar's close time 

The behavior of some functions, variables and operators has changed:

* The ``time`` variable returns the correct open time of the bar for more special cases than before

* An optional *seconds* parameter of the ``timestamp`` function allows you to set the time to within seconds 

* ``security`` function:
  
  * Added the possibility of requesting resolutions in seconds:

    1, 5, 15, 30 seconds (chart resolution should be less than or equal to the requested resolution)
    
  * Reduced the maximum value that can be requested in some of the other resolutions:
    
    from 1 to 1440 minutes
    
    from 1 to 365 days  
    
    from 1 to 52 weeks
    
    from 1 to 12 months



* Changes to the evaluation of ternary operator branches:

  In Pine v3, during the execution of a ternary operator, both its branches are calculated, so when this script is added to the chart, a long position is opened, even if the long() function is not called::

    //@version=3
    strategy(title = "My Strategy")
    long() =>
        strategy.entry("long", true, 1, when = open > high[1])
        1
    c = 0
    c := true ? 1 : long()
    plot(c)
    
  Pine v4 contains built-in functions with side effects ( ``line.new`` and ``label.new`` ). If calls to these functions are present in both branches of a ternary operator, both function calls would be executed following v3 conventions. Thus, in Pine v4, only the branch corresponding to the evaluated condition is calculated. While this provides a viable solution in some cases, it will modify the behavior of scripts which depended on the fact that both branches of a ternary were evaluated. The solution is to pre-evaluate expressions prior to the ternary operator. The conversion utility takes this requirement into account when converting scripts from v3 to v4, so that script behavior will be identical in v3 and v4.




June 2019
--------------------------

* Support for drawing objects. Added *label* and *line* drawings
* ``var`` keyword for one time variable initialization
* Type system improvements:

  * *series string* data type
  * functions for explicit type casting
  * syntax for explicit variable type declaration
  * new *input* type forms

* Renaming of built-ins and a version 3 to 4 converter utility
* ``max_bars_back`` function to control series variables internal history buffer sizes
* Pine Script documentation versioning


