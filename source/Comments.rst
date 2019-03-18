Comments
========

Pine Script has single-line comments only. Any text from the symbol
``//`` until the end of the line is considered as comment. An example::

    study("Test")
    // This line is a comment
    a = close // This is also a comment
    plot(a)

Script Editor has hotkeys for commenting/uncommenting block of code:
`Ctrl + /` Thanks to this, there is no need for multi-line comments -
one can highlight the large code fragment in Script Editor and press
`Ctrl + /`. This will comment out highlighted fragment; if
`Ctrl + /` is pressed again, commentary will be taken away.

Also, comments could not be placed in the middle of a statement wrapped
to several lines, read more here: :doc:`Lines_Wrapping`.
