
Alert conditions
----------------

The 
`alertcondition <https://www.tradingview.com/study-script-reference/#fun_alertcondition>`__ annotation function
allows you to create custom *alert conditions* in Pine studies. One study may contain more than one ``alertcondition`` calls.
The function has the following signature:

.. code-block:: text

    alertcondition(condition, title, message)

``condition``
   is a series of boolean (``true`` or ``false``) values that is used to trigger the alert.
   ``true`` means the alert condition is met and the alert
   should trigger. ``false`` means the alert condition is not met and the alert should not
   trigger. It is a required argument.

``title``
   is an optional argument that sets the name of the alert condition as it will appear in TradingView's *Create Alert* dialog box.

``message``
   is an optional argument that specifies the text message to display
   when the alert fires.

Here is an example of code creating an alert condition::

    //@version=2
    study("Example of alertcondition")
    src = input(close)
    ma_1 = sma(src, 20)
    ma_2 = sma(src, 10)
    c = cross(ma_1, ma_2)
    alertcondition(c, title='Red crosses blue', message='Red and blue have crossed!')
    plot(ma_1, color=red)
    plot(ma_2, color=blue)

The function makes the alert available in the *Create Alert*
dialog box. Please note that the ``alertcondition`` **does NOT start alerts programmatically**; 
it only gives you the opportunity to create an alert from it 
in the *Create Alert* dialog box. Alerts must always be created manually.
Also, an alert created with a custom ``alertcondition`` in Pine
code does not display anything on a chart.

To create an alert based on an ``alertcondition``, one should apply a Pine indicator 
containing an ``alertcondition`` to the current chart, open the *Create Alert*
dialog, select the indicator as the main condition for the alert and then
choose one of the specific alert conditions defined in the script's code.

.. image:: images/Alertcondition_1.png


When the alert fires, you'll see the message:

.. image:: images/Alertcondition_2.png

