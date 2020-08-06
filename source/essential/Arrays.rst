Arrays
======

.. contents:: :local:
    :depth: 2



Introduction
------------

Arrays can be used to store multiple values in one data structure. Think of them as a better way to handle cases where you would
otherwise need a set of variables named ``price00``, ``price01`` and ``price02``. Arrays are an advanced feature used for scripts 
requiring intricate data-handling. If you are a beginning Pine programmer, you may consider studying other, more accessible Pine features 
before you tackle arrays.

Pine arrays are one-dimensional. All elements of an array are of the same type, which can be *int*, *float*, *bool* or *color*, always of *series* form. 
Arrays are referenced using an array *id*, similar to label and line id's. 
As with other Pine variables, the history-referencing operator can be used with array id's to refer to past instances of an array. 
Pine does not use an indexing operator to reference individual array elements;
instead, functions like ``array.get()`` and ``array.set()`` are used to read and write values of array elements. 
Array values can be used in all Pine expressions and functions where a value of *series* form is allowed.

Elements within an array are referred to using an *index*, which starts at 0 and extends to the number or elements in the array, minus one.
Arrays in Pine can be sized dynamically, so the number of elements in the array can be modified within one iteration of the script on a bar,
and vary across bars. Multiple arrays can be used by the same script. The size of arrays is limited to 100,000 but multiple arrays of maximum size can be used in one script.

.. note:: We will use "beginning" of an array to designate index 0, and "end" of an array to designate the array's element with the highest index value. 
We will also extend the meaning of *array* to include array *id's*, for the sake of brevity.



Declaring arrays
----------------

The following syntax can be used to declare arrays::

    <type>[] <identifier> = <expression>
    var <type>[] <identifier> = <expression>

The ``[]`` modifier is appended to the type name when declaring arrays. However, since type-specific functions are used to create an array,
the ``<type>[]`` part of the declaration is redundant, except if you initialize the array id to ``na``, as in this example, 
which declares an empty array of *float* values with an array id named ``prices``::

    float[] prices = na

When declaring an array and the ``<expression>`` is not ``na``, it must be one of the ``array.new_<type>(size, initial_value)`` functions. 
The arguments of both the ``size=`` and ``initial_value=`` parameters can be *series*, so you can dynamically size and initialize arrays.
The following example also creates an array containing zero *float* elements, 
but this time the array id returned by the ``array.new_float(0)`` function call is assigned to ``prices``.
Additionally, because the ``var`` keyword is used in the declaration, the array is only initialized on the first bar,
so its values will propagate across bars::

    var prices = array.new_float(0)

Similar array creation functions exist for the other types of array elements: ``array.new_int()``, ``array.new_bool()`` and ``array.new_color()``.

When declaring an array, you can initialize all elements in the array using the ``initial_value=`` parameter. 
When no argument is supplied for ``initial_value=``, the array elements are initialized to ``na``.
The following declaration creates and array id named ``prices``.
The array is created with two elements, each initialized with the value of the value of the ``close`` built-in variable on that bar::

    prices = array.new_float(2, close)

There is currently no way to initialize array elements with different values, whether upon declaration or post-declaration, using a single function call. One is planned for the near future.

Reading and writing array values
--------------------------------

Values can be written to existing individual array elements using ``array.set(id, index, value)``, and read using ``array.get(id, index)``.
As is the case whenever an array index is used in your code, it is imperative that the index never be greater than 
the array's size, minus one (because array indices start at zero). You can obtain the size of an array by using the 
``array.size(id)`` function.

The following example uses ``array.set()`` to initialize an array of colors to instances of one base color using different transparency levels. 
It then fetches the proper array element to use it in a ``bgcolor()`` call::

    //@version=4
    study("array.set()", "", true)
    i_lookBack = input(100)
    c_fillColor = color.green
    // Declare our array of fill colors (initial value of all elements is `na`).
    var c_fills = array.new_color(5)
    // Initialize the array elements with progressively lighter shades of the fill color.
    array.set(c_fills, 0, color.new(c_fillColor, 70))
    array.set(c_fills, 1, color.new(c_fillColor, 75))
    array.set(c_fills, 2, color.new(c_fillColor, 80))
    array.set(c_fills, 3, color.new(c_fillColor, 85))
    array.set(c_fills, 4, color.new(c_fillColor, 90))
    
    // Find the offset to highest high. Change its sign because the function returns a negative value.
    lastHiBar = - highestbars(high, i_lookBack)
    // Convert the offset to an array index, capping it to 4 to avoid a runtime error.
    // The index used by `array.get()` will be the equivalent of `floor(fillNo)`.
    fillNo = min(lastHiBar / (i_lookBack / 5), 4)
    // Set background to a progressively lighter fill with increasing distance from location of highest high.
    bgcolor(array.get(c_fills, fillNo))
    // Plot key values to the Data Window for debugging.
    plotchar(lastHiBar, "lastHiBar", "", location.top, size = size.tiny)
    plotchar(fillNo, "fillNo", "", location.top, size = size.tiny)

Another technique that can be used to initialize the elements in an array is to declare the array with a zero size, and then populate it using ``array.push()`` 
to append **new** elements to the end of the array, increasing the size of the array by one at each call. 
This code is functionally identical to the initialization section from the preceding script::

    var c_fills = array.new_color(0)
    // Initialize the array elements with progressively lighter shades of the fill color.
    array.push(c_fills, color.new(c_fillColor, 70))
    array.push(c_fills, color.new(c_fillColor, 75))
    array.push(c_fills, color.new(c_fillColor, 80))
    array.push(c_fills, color.new(c_fillColor, 85))
    array.push(c_fills, color.new(c_fillColor, 90))

The ``array.fill(id, value, index_from, index_to)`` function can be used to fill contiguous sets of array elements with a value. 
Used without the last two optional parameters, the function fills the whole array, so::

    a = array.new_float(10, close)

and::

    a = array.new_float(10)
    array.fill(a, close)

are equivalent, but::

    a = array.new_float(10)
    array.fill(a, close, 1, 2)

only fills the second and third element of the array with ``close``. 
The remaining elements will hold the ``na`` value, as no intialization value was provided when the array was declared.



Scope
-----

Arrays can be declared in a script's global scope, as well as in the local scope of a function or an ``if`` branch.
One major distinction between Pine arrays and variables declared in the global scope is that global arrays can be modified from within the local scope of a function.
This new capability can be used to implement global variables that can be both read and set from within any function in the script. 
We use it here to calculate progressively lower or higher levels::

    //@version=4
    study("Bands", "", true)
    i_factor = 1 + (input(-2., "Step %") / 100)
    // Use the lowest average OHLC in last 50 bars from 10 bars back as the our base level.
    level = array.new_float(1, lowest(ohlc4, 50)[10])
    
    f_nextLevel(_val) =>
        _newLevel = array.get(level, 0) * _val
        // Write new level to the global array so it can be used as the base in the next call to the `f_nextLevel()`.
        array.set(level, 0, _newLevel)
        _newLevel
    
    plot(f_nextLevel(1))
    plot(f_nextLevel(i_factor))
    plot(f_nextLevel(i_factor))
    plot(f_nextLevel(i_factor))



Inserting and removing array elements
-------------------------------------
``array.insert()``
``array.remove()``
``array.shift()``
``array.unshift()``
``array.clear()``


Using an array as a stack
^^^^^^^^^^^^^^^^^^^^^^^^^

Stacks are LIFO (last in, first out) constructions. They behave somewhat like a vertical pile of books to which books can only be added or removed one at a time,
always from the top. Pine arrays can be used as a stack, in which case you will use the ``array.push()`` and ``array.pop()`` functions to add and remove elements at the end of the array.

``array.push(prices, close)`` will add a new element to the end of the ``prices`` array, increasing the array's size by one.

``array.pop(prices)`` will remove the end element from the ``prices`` array, return its value and decrease the array's size by one.

See how the functions are used here to remember successive lows in rallies::

    //@version=4
    study("Lows from new highs", "", true)
    var lows = array.new_float(0)
    flushHighs = false
    
    // Pop an element from the stack when `_cond` is true.
    f_array_pop(_id, _cond) => _cond and array.size(_id) > 0 ? array.pop(_id) : float(na)
    
    if rising(high, 1)
        // Consecutive high; push a new low on the stack.
        array.push(lows, low)
        // Force the return type of this `if` block to be the same as that of the next block.
        bool(na)
    else if array.size(lows) >= 4 or low < array.min(lows)
        // We have at least 4 lows or price has breached the lowest low;
        // sort lows and set flag indicating we will plot and flush the levels.
        array.sort(lows, order.ascending)
        flushHighs := true
    
    // If needed, plot and flush lows.
    lowLevel = f_array_pop(lows, flushHighs)
    plot(lowLevel, "Low 1", low > lowLevel ? color.silver : color.fuchsia, 2, plot.style_linebr)
    lowLevel := f_array_pop(lows, flushHighs)
    plot(lowLevel, "Low 2", low > lowLevel ? color.silver : color.fuchsia, 3, plot.style_linebr)
    lowLevel := f_array_pop(lows, flushHighs)
    plot(lowLevel, "Low 3", low > lowLevel ? color.silver : color.fuchsia, 4, plot.style_linebr)
    lowLevel := f_array_pop(lows, flushHighs)
    plot(lowLevel, "Low 4", low > lowLevel ? color.silver : color.fuchsia, 5, plot.style_linebr)
    
    if flushHighs
        // Clear remaining levels after the last 4 have been plotted.
        array.clear(lows)


Using an array as a queue
^^^^^^^^^^^^^^^^^^^^^^^^^

Queues are FIFO (first in, first out) constructions. They behave somewhat like cars arriving at a red light. 
New cars are queued at the end of the line, and the first car to leave will be the first one that arrived to the red light. 
In the following code example, we will be starting with an empty queue. 
We will add new values to the end of the array. When we remove a value from the queue, we will remove the oldest value, 
which is always sitting at the beginning of the array, at index zero. 
We can use ``array.push()`` to append new values at the end of the array, 
and we will be using ``array.remove()`` with an index of zero to remove the array's first element when we need to de-queue and element::

    //@version=4
    study("Queue example: Show last n High Pivots", "", true)
    i_pivotCount = input(10)
    i_pivotLegs  = input(3)
    
    pivotBars = array.new_int(0)
    label pLabel = na
     
    pHi = pivothigh(i_pivotLegs, i_pivotLegs)
    if not na(pHi)
        // New pivot found; append the bar_index of the new pivot to the end of the array.
        array.push(pivotBars, bar_index - i_pivotLegs)
        if array.size(pivotBars) > i_pivotCount
            // The queue was already full; remove its oldest element,
            // using it to delete the oldest label in the queue.
            label.delete(pLabel[bar_index - array.remove(pivotBars, 0)])
            
        pLabel := label.new(bar_index[i_pivotLegs], pHi, tostring(pHi))



Calculations on arrays
-------------------
``array.avg()``
``array.min()``
``array.max()``
``array.median()``
``array.mode()``
``array.sum()``
``array.standardize()``
``array.stdev()``
``array.variance()``
``array.covariance()``



Manipulating arrays
-------------------

Concatenation
^^^^^^^^^^^^^

Two arrays can be merged—or concatenated—using ``array.concat()``. When arrays are merged, the second array is appended to the end of the first, 
so the first array is modified while the second one remains intact. The function returns the array id of the first array::

    //@version=4
    study("`array.concat()`")
    a = array.new_float(0)
    b = array.new_float(0)
    array.push(a, 0)
    array.push(a, 1)
    array.push(b, 2)
    array.push(b, 3)
    if barstate.islast
        label.new(bar_index, 0, "BEFORE\na: " + tostring(a) + "\nb: " + tostring(b))
        _c = array.concat(a, b)
        array.push(_c, 4)
        label.new(bar_index, 0, "AFTER\na: " + tostring(a) + "\nb: " + tostring(b) + "\nc: " + tostring(_c), style = label.style_label_up)


Copying
^^^^^^^

You can copy an array using ``array.copy()``. Here we copy the array ``a`` to a new array named ``_b``::

    //@version=4
    study("`array.copy()`")
    a = array.new_float(0)
    array.push(a, 0)
    array.push(a, 1)
    if barstate.islast
        _b = array.copy(a)
        array.push(_b, 2)
        label.new(bar_index, 0, "a: " + tostring(a) + "\n_b: " + tostring(_b))

Note that simply using ``_b = a`` in the previous example would not have copied the array, but only its id. 
From thereon, both variables would point to the same array, so using either one would affect the same array.

Sorting
^^^^^^^

Arrays can be sorted in either ascending or descending order using ``array.sort()``. The ``order`` parameter is optional and defaults to ``order.ascending``. 
It is of form *series*, so can be determined at runtime, as is done here. Note that which array is sorted is also determined at runtime::

    //@version=4
    study("`array.sort()`")
    a = array.new_float(0)
    b = array.new_float(0)
    array.push(a, 2)
    array.push(a, 0)
    array.push(a, 1)
    array.push(b, 4)
    array.push(b, 3)
    array.push(b, 5)
    if barstate.islast
        _barUp = close > open
        array.sort(_barUp ? a : b, _barUp ? order.ascending : order.descending)
        label.new(bar_index, 0, "a " + (_barUp ? "is sorted ▲: " : ": ") + tostring(a) + "\n\n")
        label.new(bar_index, 0, "b " + (_barUp ? ": " : "is sorted ▼: ") + tostring(b))

Reversing
^^^^^^^^^

Use ``array.reverse()`` to reverse an array::

    //@version=4
    study("`array.reverse()`")
    a = array.new_float(0)
    array.push(a, 0)
    array.push(a, 1)
    array.push(a, 2)
    if barstate.islast
        array.reverse(a)
        label.new(bar_index, 0, "a: " + tostring(a) + "\n\n")

Slicing
^^^^^^^

Slicing an array creates a shadow of a subset of that array. Once the shadow is created using ``array.slice()``, operations on the shadow are also mirrored on the original array. You slice by specifying ``index_from`` and ``index_to`` array indices. The ``index_to`` argument must be one greater than the end of the subset you want to shadow, 
so as in the example here, to shadow the subset from index 1 to 2 of array ``a``, you need to use ``_shadowOfA = array.slice(a, 1, 3)``::

    //@version=4
    study("`array.slice()`")
    a = array.new_float(0)
    array.push(a, 0)
    array.push(a, 1)
    array.push(a, 2)
    array.push(a, 3)
    if barstate.islast
        // Create a shadow of elements at index 1 and 2 from array `a`.
        _shadowOfA = array.slice(a, 1, 3)
        label.new(bar_index, 0, "BEFORE\na: " + tostring(a) + "\n_shadowOfA: " + tostring(_shadowOfA))
        // Add a new element at the end of the shadow array, thus also affecting the original array `a`.
        array.push(_shadowOfA, 4)
        label.new(bar_index, 0, "AFTER\na: " + tostring(a) + "\n_shadowOfA: " + tostring(_shadowOfA), style = label.style_label_up)



Searching arrays
----------------

We can test if a value is part of an array with the ``array.includes()`` function, which returns true if the element is found.
We can find the first occurrence of a value in an array by using the ``array.indexof()`` function. The first occurence is the one with the lowest index.
We can also find the last occurrence of a value with ``array.lastindexof()``::

    //@version=4
    study("Searching in arrays")
    _value = input(1)
    a = array.new_float(0)
    array.push(a, 0)
    array.push(a, 1)
    array.push(a, 2)
    array.push(a, 1)
    if barstate.islast
        _valueFound      = array.includes(a, _value)
        _firstIndexFound = array.indexof(a, _value)
        _lastIndexFound  = array.lastindexof(a, _value)
        label.new(bar_index, 0, "a: " + tostring(a) + 
          "\nFirst " + tostring(_value) + (_firstIndexFound != -1 ? " value was found at index: " + tostring(_firstIndexFound) : " value was not found.") +
          "\nLast " + tostring(_value)  + (_lastIndexFound  != -1 ? " value was found at index: " + tostring(_lastIndexFound) : " value was not found."))



Error handling
--------------

Malformed ``array.*()`` call syntax in Pine scripts will cause the usual **compiler** error messages to appear in Pine Editor's console at the bottom of the window, 
when you save a script. Refer to the Pine Reference Manual when in doubt regarding the exact syntax of function calls.

Scripts using arrays can also throw **runtime** errors, which appear in place of the indicator's name on charts. 
We discuss those runtime errors in this section.

Index xx is out of bounds. Array size is yy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This will most probably be the most frequent error you encounter. It will happen when you reference an inexistent array index. 
The "xx" value will be the value of the faulty index you tried to use, and "yy" will be the size of the array. 
Recall that array indices start at zero—not one—and end at the array's size, minus one. An array of size 3's last valid index is thus ``2``.

To avoid this error, you must make provisions in your code logic to prevent using an index lying outside the array's index boundaries. 
This code will generate the error because the last index we use in the loop is outside the valid index range for the array::

    //@version=4
    study("Out of bounds index")
    a = array.new_float(3)
    for _i = 1 to 3
        array.set(a, _i, _i)
    plot(array.pop(a))

The correct ``for`` statement is::

    for _i = 0 to 2

When you size arrays dynamically using a field in your script's *Settings/Inputs" tab, protect the boundaries of that value using 
``input()``'s ``minval`` and ``maxval`` parameters::

    //@version=4
    study("Protected array size")
    i_size = input(10, "Array size", minval = 1, maxval = 100000)
    a = array.new_float(i_size)
    for _i = 0 to i_size - 1
        array.set(a, _i, _i)
    plot(array.size(a))


Calculation takes too long to execute (> 20000 ms)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Cannot modify an array when its id is `na`**

**Array is too large. Maximum size is 100000**

**Cannot create an array with a negative size**

**Cannot call `pop()` if array is empty**

**Index 'from' should be less than index 'to'**

**Index is out of bounds**


═══════════════════════ JUNK ═════════════════════════

Starting with Pine v4, indicators and strategies can
create *drawing objects* on the chart. Two types of
drawings are currently supported: *label* and *line*.
You will find one instance of each on the following chart:

.. image:: images/label_and_line_drawings.png

.. note:: On TradingView charts, a complete set of *Drawing Tools*
  allows users to create and modify drawings using mouse actions. While they may look similar to
  drawing objects created with Pine code, they are essentially different entities.
  Drawing objects created using Pine code cannot be modified with mouse actions.

The new line and label drawings in Pine v4 allow you to create indicators with more sophisticated
visual components, e.g., pivot points, support/resistance levels,
zig zag lines, labels containing dynamic text, etc.

In contrast to indicator plots (plots are created with functions ``plot``, ``plotshape``, ``plotchar``),
drawing objects can be created on historical bars as well as in the future, where no bars exist yet.

Pine drawing objects are created with the `label.new <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}new>`__
and `line.new <https://www.tradingview.com/pine-script-reference/v4/#fun_line{dot}new>`__ functions.
While each function has many parameters, only the coordinates are mandatory.
This is an example of code used to create a label on every bar::

    //@version=4
    study("My Script", overlay=true)
    label.new(bar_index, high)

.. image:: images/minimal_label.png

The label is created with the parameters ``x=bar_index`` (the index of the current bar,
`bar_index <https://www.tradingview.com/pine-script-reference/v4/#var_bar_index>`__) and ``y=high`` (high price of the current bar).
When a new bar opens, a new label is created on it. Label objects created on previous bars stay on the chart
until the indicator deletes them with an explicit call of the `label.delete <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}delete>`__
function, or until the automatic garbage collection process removes them.

Here is a modified version of the same script that shows the values of the ``x`` and ``y`` coordinates used to create the labels::

    //@version=4
    study("My Script", overlay=true)
    label.new(bar_index, high, style=label.style_none,
              text="x=" + tostring(bar_index) + "\ny=" + tostring(high))

.. image:: images/minimal_label_with_x_y_coordinates.png

In this example labels are shown without background coloring (because of parameter ``style=label.style_none``) but with
dynamically created text (``text="x=" + tostring(bar_index) + "\ny=" + tostring(high)``) that prints label coordinates.

This is an example of code that creates line objects on a chart::

    //@version=4
    study("My Script", overlay=true)
    line.new(x1=bar_index[1], y1=low[1], x2=bar_index, y2=high)

.. image:: images/minimal_line.png


Calculation of drawings on bar updates

Drawing objects are subject to both *commit* and *rollback* actions, which affect the behavior of a script when it executes
in the realtime bar, :doc:`/language/Execution_model`.

This script demonstrates the effect of rollback when running in the realtime bar::

    //@version=4
    study("My Script", overlay=true)
    label.new(bar_index, high)

While ``label.new`` creates a new label on every iteration of the script when price changes in the realtime bar,
the most recent label created in the script's previous iteration is also automatically deleted because of rollback before the next iteration. Only the last label created before the realtime bar's close will be committed, and will thus persist.

.. _drawings_coordinates:

Coordinates

Drawing objects are positioned on the chart according to *x* and *y* coordinates using a combination of 4 parameters: ``x``, ``y``, ``xloc`` and ``yloc``. The value of ``xloc`` determines whether ``x`` will hold a bar index or time value. When ``yloc=yloc.price``, ``y`` holds a price. ``y`` is ignored when ``yloc`` is set to `yloc.abovebar <https://www.tradingview.com/pine-script-reference/v4/#var_yloc{dot}abovebar>`__ or `yloc.belowbar <https://www.tradingview.com/pine-script-reference/v4/#var_yloc{dot}belowbar>`__.

If a drawing object uses `xloc.bar_index <https://www.tradingview.com/pine-script-reference/v4/#var_xloc{dot}bar_index>`__, then
the x-coordinate is treated as an absolute bar index. The bar index of the current bar can be obtained from the built-in variable ``bar_index``. The bar index of previous bars is ``bar_index[1]``, ``bar_index[2]`` and so on. ``xloc.bar_index`` is the default value for x-location parameters of both label and line drawings.

If a drawing object uses `xloc.bar_time <https://www.tradingview.com/pine-script-reference/v4/#var_xloc{dot}bar_time>`__, then
the x-coordinate is treated as a UNIX time in milliseconds. The start time of the current bar can be obtained from the built-in variable ``time``.
The bar time of previous bars is ``time[1]``, ``time[2]`` and so on. Time can also be set to an absolute time point with the
`timestamp <https://www.tradingview.com/pine-script-reference/v4/#fun_timestamp>`__ function.

The ``xloc.bar_time`` mode makes it possible to place a drawing object in the future, to the right of the current bar. For example::

    //@version=4
    study("My Script", overlay=true)
    dt = time - time[1]
    if barstate.islast
        label.new(time + 3*dt, close, xloc=xloc.bar_time)

.. image:: images/label_in_the_future.png

This code places a label object in the future. X-location logic works identically for both label and line drawings.

In contrast, y-location logic is different for label and line drawings.
Pine's *line* drawings always use `yloc.price <https://www.tradingview.com/pine-script-reference/v4/#var_yloc{dot}price>`__,
so their y-coordinate is always treated as an absolute price value.

Label drawings have additional y-location values: `yloc.abovebar <https://www.tradingview.com/pine-script-reference/v4/#var_yloc{dot}abovebar>`__ and
`yloc.belowbar <https://www.tradingview.com/pine-script-reference/v4/#var_yloc{dot}belowbar>`__.
When they are used, the value of the ``y`` parameter is ignored and the drawing object is placed above or below the bar.


The available *setter* functions for label drawings are:

    * `label.set_color <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_color>`__ --- changes color of label
    * `label.set_size <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_size>`__ --- changes size of label
    * `label.set_style <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_style>`__ --- changes :ref:`style of label <drawings_label_styles>`
    * `label.set_text <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_text>`__ --- changes text of label
    * `label.set_textcolor <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_textcolor>`__ --- changes color of text
    * `label.set_x <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_x>`__ --- changes x-coordinate of label
    * `label.set_y <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_y>`__ --- changes y-coordinate of label
    * `label.set_xy <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_xy>`__ --- changes both x and y coordinates of label
    * `label.set_xloc <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_xloc>`__ --- changes x-location of label
    * `label.set_yloc <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_yloc>`__ --- changes y-location of label
    * `label.set_tooltip <https://www.tradingview.com/pine-script-reference/v4/#fun_label{dot}set_tooltip>`__ --- changes tooltip of label


