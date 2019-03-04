.. raw:: mediawiki

   {{Languages}}

Pine, besides operators, also has functions and annotation functions.
Occasionally, for brevity’s sake, this manual will refer to annotation
functions as simply annotations. Syntactically they are similar (however
there are some differences which will now be discussed), but they have
different purposes and usage effects.

Functions are used for calculating values and always return a result.
Functions never have side effects. Function calls are used in
expressions along with operators. Essentially, they determine the
calculation algorithm. Functions are divided into built-in or custom
(user-defined). Examples of built-in functions:
`sma <Moving_Average#Simple_Moving_Average_(SMA)>`__,
`ema <Moving_Average#Exponential_Moving_Average_(EMA)>`__,
`iff <Operators#Conditional_Operator_.3F_and_the_Function_iff>`__.

Function annotations are used for determining meta information which
describes an indicator being created (they also have side effects). All
annotations are built-in. Annotations may

-  assign a name to an indicator
-  determine which variables appear incoming and outgoing (by default,
   It’s also possible to assign a name and default values for incoming
   variables). Outgoing variables are displayed on the chart as graphs
   or other layouts.
-  some other visual effects (e.g., background coloring)

Name, color and each graph’s display style are determined in
annotations. Examples of function annotations:
`study <https://www.tradingview.com/study-script-reference/#fun_study>`__,
`input <https://www.tradingview.com/study-script-reference/#fun_input>`__,
`plot <https://www.tradingview.com/study-script-reference/#fun_plot>`__.

A few annotations have not only side effects (in the form of determining
meta information) but also return a result. ‘Plot’ and ‘hline’ are such
annotations. However this result can be used only in other annotations
and can’t take part in the indicator’s calculations (see `annotation
‘fill’ <https://www.tradingview.com/study-script-reference/#fun_fill>`__).

Syntactically, user-defined functions, built-in functions and annotation
functions are similar in use within the script: to use either function
or annotation one should specify its name as well as the list of actual
arguments in parentheses. The main difference is in usage semantic.
Also, there is a difference in passing arguments - annotations and
built-in functions accept keyword arguments while user-defined functions
does not (see `release note on kwargs in built-in
functions <Pine_Script:_Release_Notes#2017-04-17:_kwargs_syntax_for_all_builtin_functions>`__).

Function calls allows to pass arguments only by position. For most of
programming languages it's the only available method of arguments
passing. Function annotation calls also accepts keyword arguments. This
allows to specify only part of arguments leaving others by default.
Compare the following:

::

    study('Example', 'Ex', true)

and

::

    study(title=‘Example’, shorttitle=’Ex’, overlay=true)

It’s possible to mix positional and keyword arguments. Positional
arguments must go first and keyword arguments should follow them. So the
following call is not valid:

::

    study(precision=3, ‘Example’)

--------------

Previous: `Operators <Operators>`__, Next: `Expressions, Declarations
and Statements <Expressions,_Declarations_and_Statements>`__, Up: `Pine
Script Tutorial <Pine_Script_Tutorial>`__

`Category:Pine Script <Category:Pine_Script>`__
