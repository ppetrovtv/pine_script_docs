.. raw:: mediawiki

   {{Languages}}

In Pine Script there is an extensive library of built-in functions which
can be used to create indicators. Apart from these functions, the user
is able to create his or her own personal functions in Pine.

Single-line Functions
---------------------

Simple short functions are convenient to write on one line. The
following is the syntax of single-line functions: () => The name of the
function is located before the parentheses. Then, located in parenthesis
is , which is simply a list of function arguments separated by a comma.
in the example is the function’s body.

Here is an example of a single-line function: f(x, y) => x + y

After the function ‘f’ has been determined, it’s possible to call it: a
= f(open, close) b = f(2, 2) c = f(open, 2)

Pay attention to the fact that the type of result which is being
returned by the function ‘f’ can be different. In the example above, the
type of variable ‘a’ will be a series. The type of variable ‘b’ is an
integer. The type of variable ‘c’ is a series. Pine uses dynamic
arguments typing so you should not assign the type of each argument.

The type of result is deduced automatically. It depends on the type of
arguments which were passed to the function and the statements of the
function body.

Footnote: in Pine it’s possible to call other functions from functions —
except the original function, i.e., recursion is not supported.

Multi-line Functions
--------------------

Of course it’s difficult to do any sort of advanced calculations with
only one-line functions. So we decided to expand the syntax of declaring
functions by making them multiline. Here’s a syntax of a multiline
function: () =>

| ``   ``\ 
| ``   ...``
| ``   ``\ 
| ``   ``\ \ `` or ``\ 

 The body of a multi-line function consists of a few statements. Each
statement is placed on a separate line and must be preceded by 1
indentation (four spaces or 1 tab). The indentation before the statement
indicates that it is part of the body of the function and not in the
global scope. The first statement met that is placed without an indent
(at the start of the line) will indicate that the body of the function
has finished on the previous statement.

Either an expression or a declared variable should be the last statement
of the function’s body. The result of this expression (or variable) will
be a result of the entire function’s call.

For example: geom\_average(x, y) =>

| ``   a = x*x``
| ``   b = y*y``
| ``   sqrt(a + b)``

The function ‘geom\_average’ has two arguments and creates two variables
in the body: ‘a’ and ‘b’. The last statement calls the function ‘sqrt’
(an extraction of the square root). The ‘geom\_average’ call will return
the last expression value ``(sqrt(a+b))``.

Scopes in the Script
--------------------

Variables which are declared outside the body of any function belong to
the global scope. User-declared functions also belong to the global
scope. All built-in variables and functions also belong to the global
scope.

Each function has its own “local scope”. All the variables declared
inside the function (and this function arguments too) belong to scope of
that function, meaning that it is impossible to reference them from
outside — e.g., from the global scope or the local scope of another
function. At the same time, from the scope of any function, it’s
possible to refer to any variable declared in the global scope.

So it's possible to reference any global user variables and functions
(apart from recursive calls) and built-in variables/functions from user
function's body. One can say that the local scope has been embedded the
the global one.

In Pine, nested functions are not allowed, i.e. one can’t declare
function inside another function. All user functions are declared in the
global scope. Local scopes do not intersect between one another.

Functions with ‘self ref’ Variables in the Body
-----------------------------------------------

The body of a multi-line function is a sequence of expressions and/or
variable declarations. Any variable that is being declared in the body
of a function can be a self referencing one. An example of the function
``my_sma`` which is equivalent to the built-in function ``sma``:

study(“Custom Simple MA”, overlay=true) my\_sma(src, len) =>

| ``   sum = nz(sum[1]) - nz(src[len]) + src``
| ``   sum/len   ``

plot(my\_sma(close, 9))

Pay attention to the use of function ``nz`` to prevent NaN values; they
appear from the left side of the series as a result of shifting it to
the right.

A slightly more difficult example, the function ``my_ema`` is identical
to the built-in function ``ema``:

study(“Custom Exp MA”, overlay=true) my\_ema(src, len) =>

| ``   weight = 2.0 / (len + 1)``
| ``   sum = nz(sum[1]) - nz(src[len]) + src``
| ``   ma = na(src[len]) ? na : sum/len``
| ``   out = na(out[1]) ? ma : (src - out[1]) * weight + out[1]``
| ``   out``

plot(my\_ema(close, 9))

Pay attention to the fact ``out`` is the last statement of the function
``my_ema``. It is a simple expression consisting of one of the variable
reference. The value of the variable ``out`` in particular, is a value
being returned by the whole function ``my_ema``. If the last expression
is a variable declaration then its value will be the function's result.
So the following two functions are completely the same:

f1(x) =>

| ``   a = x + a[1]``
| ``   a``

f2(x) =>

``   a = x + a[1]``\ 

Functions that return multiple result
-------------------------------------

In most cases a function returns one result. But it is possible to
return a list of results: fun(x, y) =>

| ``   a = x+y``
| ``   b = x-y``
| ``   [a, b]``\ 

There is a special syntax for calling such functions: [res0, res1] =
fun(open, close) plot(res0) plot(res1)

--------------

Previous: `Expressions, Declarations and
Statements <Expressions,_Declarations_and_Statements>`__, Next:
`Lines\_Wrapping <Lines_Wrapping>`__, Up: `Pine Script
Tutorial <Pine_Script_Tutorial>`__

`Category:Pine Script <Category:Pine_Script>`__
