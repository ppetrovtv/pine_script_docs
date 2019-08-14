Release notes
=============

.. contents:: :local:
    :depth: 2

This page contains release notes of notable changes in Pine Script.

July-August 2019
--------------------------


New variables added: 


* ``timeframe.isseconds`` returns true when current resolution is in seconds
    
* ``timeframe.isminutes`` returns true when current resolution is in minutes
    
* ``time_close`` returns the current bar's close time 

The behavior of some functions, variables and operators has changed:

* ``time`` variable returns the correct open time of the bar for more special cases than before

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


