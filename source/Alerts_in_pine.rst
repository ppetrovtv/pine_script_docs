Annotation function ``alertcondition`` allows you to create custom alert
conditions in Pine studies.

The function has the following signature:

::

    alertcondition(condition, title, message)

``condition`` is a series of boolean values that is used for alert.
Available values: true, false. True means alert condition is met, alert
should trigger. False means alert condition is not met, alert should not
trigger. It is a required argument.

``title`` is an optional argument that sets the name of the alert
condition.

``message`` is an optional argument that specifies text message to
display when the alert fires.

Here is example of creating an alert condition:

::

    //@version=2
    study("Example of alertcondition")
    src = input(close)
    ma_1 = sma(src, 20)
    ma_2 = sma(src, 10)
    c = cross(ma_1, ma_2)
    alertcondition(c, title='Red crosses blue', message='Red and blue have crossed!')
    plot(ma_1, color=red)
    plot(ma_2, color=blue)

The function creates alert condition that is available in Create Alert
dialog. **Note**, that alertcondition does NOT fire alerts from code
automatically, it only gives you opportunity to create a custom
condition for Create Alert dialog. Alerts must be still set manually.
Also, an alert triggered based on a custom condition you created in Pine
code is not displayed on a chart.

One script may include more than one alertcondition.

To create an alert based on alertcondition, one should apply a Pine code
(study) with alertcondition to current chart, open the Create Alert
dialog, select the applied Pine code as main condition for the alert and
choose the specific alert condition (implemented in the code itself).

.. figure:: images/Pine_alertcondition_.png
   :alt: images/Pine_alertcondition_.png

   images/Pine\_alertcondition\_.png
