from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace

# Many examples are here https://bitbucket.org/birkenfeld/pygments-main/src/default/pygments/styles/default.py

class PineStyle(Style):
    background_color = "#f8f8f8"
    default_style = ""

    styles = {
        Whitespace:                "#bbbbbb",
        Comment:                   "italic #408080",

        Keyword:                   "bold #008000",

        Operator:                  "#666666",

        Name:                      "#101010",
        Name.Constant:             "bold #800000",
        Name.Entity:               "bold #008000",

        String:                    "#BA2121",
        Number:                    "#6666FF",

        Error:                     "border:#FF0000"
    }
