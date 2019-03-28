Declaring functions
===================

.. contents:: :local:
    :depth: 2

In Pine Script there is an extensive library of built-in functions which
can be used to create indicators. Apart from these functions, the user
is able to create his or her own personal functions in Pine.

Single-line functions
---------------------

Simple short functions are convenient to write on one line. The
following is the syntax of single-line functions:

.. code-block:: text

    <identifier>(<list of arguments>) => <expression>

The name of the function is located before the parentheses. Then,
located in parenthesis is, which is simply a list of function arguments
separated by a comma. in the example is the function's body.

Here is an example of a single-line function::

    f(x, y) => x + y

After the function ``f`` has been declared, it's possible to call it::

    a = f(open, close)
    b = f(2, 2)
    c = f(open, 2)

Pay attention to the fact that the type of function ``f`` return value is determined automatically 
and depends on arguments types of a particular function call. In the example above, the
type of variable ``a`` is *series*, because arguments are both *series*. The type of variable ``b`` is 
*integer*, because arguments are both *literal integers*. The type of variable ``c`` is *series*, 
because addition of *series* and *literal integer* produces *series* result.

Pine Scipt functions do not support recursion. It is not allowed for a function to call itself from within its own code.


.. _multi_line_functions:

Multi-line functions
--------------------

Of course it's difficult to do any sort of advanced calculations with
only one-line functions. That is why Pine Script has a syntax of declaring
multiline functions:

.. code-block:: text

    <identifier>(<list of arguments>) =>
        <variable declaration>
        ...
        <variable declaration or expression>

The body of a multi-line function consists of a several statements. Each
statement is placed on a separate line and must be preceded by 1
indentation (4 spaces or 1 tab). The indentation before the statement
indicates that it is a part of the body of the function and not a part of the
global scope. The first statement met that is placed without an indent
(at the start of the line) will indicate that the body of the function
has finished on the previous statement.

Either an expression or a declared variable should be the last statement
of the function's body. The result of this expression (or variable) will
be a result of the entire function's call. For example::

    geom_average(x, y) =>
        a = x*x
        b = y*y
        sqrt(a + b)

The function ``geom_average`` has two arguments and creates two variables
in the body: ``a`` and ``b``. The last statement calls the function ``sqrt``
(an extraction of the square root). The ``geom_average`` call will return
the last expression value ``(sqrt(a + b))``.

Scopes in the script
--------------------

Variables which are declared outside the body of any function belong to
the *global* scope. User-declared functions also belong to the global
scope. All built-in variables and functions also belong to the global
scope.

Each function has its own *local* scope. All the variables declared
within the function (and the function arguments too) belong to scope of
that function, meaning that it is impossible to reference them from
outside --- e.g., from the global scope or the local scope of another
function. At the same time, from the scope of any function, it's
possible to refer to any variable declared in the global scope.

So it's possible to reference any global user variables and functions
(apart from recursive calls) and built-in variables/functions from user
function's body. One can say that the local scope is embedded into the
the global one.

In Pine, nested functions are not allowed, i.e. one can't declare
function inside another function. All user functions are declared in the
global scope. Local scopes do not intersect between one another.

Functions with 'self ref' variables in the body
-----------------------------------------------

.. note:: :ref:`Self referencing variables<self_ref_variables>` are not supported since Pine Script version 3.

The body of a multi-line function is a sequence of expressions and/or
variable declarations. Any variable that is being declared in the body
of a function can be a self referencing one. An example of the function
``my_sma`` which is equivalent to the built-in function ``sma``::

    study("Custom Simple MA", overlay=true)
    my_sma(src, len) =>
        sum = nz(sum[1]) - nz(src[len]) + src
        sum/len   
    plot(my_sma(close, 9))

Pay attention to the use of function ``nz`` to prevent ``na`` values; they
appear from the left side of the series as a result of shifting it to
the right.

A slightly more difficult example, the function ``my_ema`` is identical
to the built-in function ``ema``:

::

    study("Custom Exp MA", overlay=true)
    my_ema(src, len) =>
        weight = 2.0 / (len + 1)
        sum = nz(sum[1]) - nz(src[len]) + src
        ma = na(src[len]) ? na : sum/len
        out = na(out[1]) ? ma : (src - out[1]) * weight + out[1]
        out
    plot(my_ema(close, 9))

Pay attention to the fact ``out`` is the last statement of the function
``my_ema``. It is a simple expression consisting of one of the variable
reference. The value of the variable ``out`` in particular, is a value
being returned by the whole function ``my_ema``. If the last expression
is a variable declaration then its value will be the function's result.
So the following two functions are completely the same::

    f1(x) =>
        a = x + a[1]
        a
    
    f2(x) =>
        a = x + a[1]

Functions that return multiple result
-------------------------------------

In most cases a function returns one result. But it is possible to
return a list of results (a *tuple*-like result)::

    fun(x, y) =>
        a = x+y
        b = x-y
        [a, b]

There is a special syntax for calling such functions:

::

    [res0, res1] = fun(open, close)
    plot(res0)
    plot(res1)
