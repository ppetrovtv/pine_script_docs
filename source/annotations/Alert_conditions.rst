
Alert conditions
----------------

The annotation function
`alertcondition <https://www.tradingview.com/study-script-reference/#fun_alertcondition>`__
allows you to create custom *alert conditions* in Pine indicators. One script may have one or more ``alertcondition`` calls.
The function has the following signature:

.. code-block:: text

    alertcondition(condition, title, message)

``condition``
   is a series of boolean (``true`` or ``false``) values that is used for alert.
   ``true`` means that the alert condition is met, alert
   should trigger. ``false`` means that the alert condition is not met, alert should not
   trigger. It is a required argument.

``title``
   is an optional argument that sets the name of the alert condition.

``message``
   is an optional argument that specifies text message to display
   when the alert fires.

Here is example of creating an alert condition::

    //@version=2
    study("Example of alertcondition")
    src = input(close)
    ma_1 = sma(src, 20)
    ma_2 = sma(src, 10)
    c = cross(ma_1, ma_2)
    alertcondition(c, title='Red crosses blue', message='Red and blue have crossed!')
    plot(ma_1, color=red)
    plot(ma_2, color=blue)

The function creates alert condition that is available in *Create Alert*
dialog. Please note, that alertcondition **does NOT start alerts programmatically**, 
it only gives you opportunity to create a custom
condition for *Create Alert* dialog. Alerts must be still started manually.
Also, an alert created with a custom ``alertcondition`` in Pine
code is not displayed on a chart.

To create an alert based on an alertcondition, one should apply a Pine indicator 
with an alertcontidion to the current chart, open the *Create Alert*
dialog, select the applied Pine code as main condition for the alert and
choose the specific alert condition (implemented in the code itself).

.. image:: images/Alertcondition_1.png


When alert fires, you'll see the message:

.. image:: images/Alertcondition_2.png

