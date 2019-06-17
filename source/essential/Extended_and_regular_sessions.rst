..    include:: <isonum.txt>

Extended and regular sessions
=============================

On TradingView there is an option (*right click* on chart, then *Properties* |rarr|
*Timezone/Sessions* |rarr| *Extended Hours*) that controls type of current chart
session. There are two types of session: *regular* (without pre and post market
data) and *extended* (with them). In Pine Scripts it is possible
to specify session type for additional data, that is requested with the
`security <https://www.tradingview.com/pine-script-reference/v4/#fun_security>`__ function.

Usually you pass to ``security`` function first argument symbol name in
form of *EXCHANGE_PREFIX:TICKER*, e.g. BATS:AAPL. In such a case,
data with regular session type will be requested. For example::

    //@version=4
    study("Example 1: Regular Session Data")
    cc = security("BATS:AAPL", timeframe.period, close, true)
    plot(cc, style=plot.style_linebr)

.. image:: images/Pine-_Regular_Session_Data.png

If you want to request the same data but with extended session type, you
should use `tickerid <https://www.tradingview.com/study-script-reference/#fun_tickerid>`__ function, 
for example::

    //@version=4
    study("Example 2: Extended Session Data")
    t = tickerid("BATS", "AAPL", session.extended)
    cc = security(t, timeframe.period, close, true)
    plot(cc, style=plot.style_linebr)

.. image:: images/Pine_Extended_Session_Data.png


Now you should see the difference --- the gaps are filled with data.

First argument of ``tickerid`` function is an exchange prefix ("BATS"), and the
second argument is a ticker ("AAPL"). Third argument specifies the type
of the session (``session.extended``). There is also a built-in variable
``session.regular`` for requesting regular session data. So, *Example 1*
could be rewritten as::

    //@version=4
    study("Example 3: Regular Session Data (using tickerid)")
    t = tickerid("BATS", "AAPL", session.regular)
    cc = security("BATS:AAPL", timeframe.period, close, true)
    plot(cc, style=plot.style_linebr)

If you want to request the same session that is set for the current main
symbol, just omit the third argument. It is optional. Or, if you want to
explicitly declare in the code your intentions, pass ``syminfo.session``
built-in variable as third parameter to ``tickerid`` function. Variable
``syminfo.session`` holds the session type of the current main symbol::

    //@version=4
    study("Example 4: Same as Main Symbol Session Type Data")
    t = tickerid("BATS", "AAPL", syminfo.session)
    cc = security(t, timeframe.period, close, true)
    plot(cc, style=plot.style_linebr)

Writing code similar to *Example 4* whatever session type you set in
*Chart Properties*, your Pine Script would use the same type.
