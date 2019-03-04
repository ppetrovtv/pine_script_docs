We created our own coding language called `Pine
Script <https://blog.tradingview.com/en/tradingview-s-pine-script-introduction-203/>`__,
which allows users to create customized studies and signals and run them
on our servers. Please note that Pine was designed as a lightweight
language, focused on the specific task of developing indicators. Since
its creation, all pre-built indicators have been coded in Pine. It's our
explicit goal to keep it accessible and easy to understand to the widest
possible audience. Please note that Pine is cloud-based and therefore
different in nature to client-side solutions. Please also note that it's
not our goal to have a language with high-end coding capabilities for
building very complex tools. In this sense Pine cannot be compared to a
full-blown programming language, but we are happy to consider any
request to add a feature. Improving it further and making it more
powerful is one of the highest priorities for us.

Because each study uses computational resources in the cloud, we have
put limits on certain aspects of Pine (as few as possible but as many as
needed) in order to share these resources fairly among our users. We
need to ensure the platform keeps running smoothly and no-one is
negatively affected by scripts that might otherwise consume a
disproportionate amount of power. The imposed limits apply to elements
such as the amount of data from additional symbols, loop calculations,
memory usage and script size. Additionally, we keep Pine `syntax and
semantics <https://www.tradingview.com/study-script-reference/>`__
simple so it can handle common tasks efficiently. We will continue to
improve the documentation and support to ensure that anyone who wants to
can `learn and use Pine <Pine_Script_Tutorial>`__, which will help the
development community grow, get more robust and create more helpful
analysis.

| **Choosing a licence**
| Choosing a license or not is entirely up to you. You are under no
  obligation to do so. If you publish scripts with open source code you
  can select a license of your choice. You can include the license in
  the comments section of a script (preferably in the beginning). Our
  position on the matter is very much like that of
  `GitHub <https://help.github.com/articles/licensing-a-repository/>`__.

Versions
--------

Currently there are three versions of Pine Script Language. A special
attribute must be used in the first line of a code to switch between
versions ``//@version=N`` where ``N`` is number. Note, that Pine Script
Language versions are incompatible with each other.

Features introduced in version 2:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `mutable
   variables <Expressions,_Declarations_and_Statements#Variable_Assignment>`__,
-  `if
   statement <Expressions,_Declarations_and_Statements#.E2.80.98if.E2.80.99_statement>`__,
-  `for
   statement <Expressions,_Declarations_and_Statements#.E2.80.98for.E2.80.99_statement>`__.

Features introduced in version 3:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. figure:: Pine_Script_logo_text.png
   :alt: Pine_Script_logo_text.png

   Pine\_Script\_logo\_text.png

-  new security behavour, controlled by parameter:
   `lookahead <Context_Switching,_The_‘security’_Function#Barmerge:_gaps_and_lookahead>`__,
-  self-referenced and forward-referenced variables removed,
-  changes in type system: forbid math operations on booleans,
-  `input with
   options <https://blog.tradingview.com/en/several-new-features-added-pine-scripting-language-3933/>`__,
-  `keyword arguments supported in all built-in
   functions <https://blog.tradingview.com/en/kwargs-syntax-now-covers-built-functions-3914/>`__,
-  `compile time
   constants <https://blog.tradingview.com/en/possibilities-compile-time-constants-4127/>`__.

See `Version 3 Release
Notes <Pine_Script:_Release_Notes#Pine_Version_3>`__ and `Migration
Guide <Pine_Version_3_Migration_Guide>`__ for details.
