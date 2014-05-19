Parsing-With-Derivatives
========================

Regex matcher based on:
http://matt.might.net/articles/implementation-of-regular-expression-matching-in-scheme-with-derivatives/.

The derivative of a regex with respect to a character c is the regex that matches a string assuming c was already matched. By computing the derivative for each character of input we can avoid constructing an nfa or backtracking, leading to a simpler and more concise implementation.
