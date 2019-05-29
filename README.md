# Combination-Algorithm-Writer-with-Predicates
Combination Algorithm Writer with Predicates

Combination Algorithm Writer with Predicates is a SWI-Prolog algorithm that finds combinations of predicates (in algdict.pl) that satisfy the given input and output.

Installation
Load all files in the form:
['filename'].

Running

caw00(off,function3,[],5,7,[[a,1],[b,1]],[[c,2]],[],Program),writeln(Program).

[[function3,[a,b,c],:-,[[function1,[b,b,d]],[=,[c,d]]]],[function1,[a,b,c],:-,[[c,is,a+b]]]]

Note:
Use (:-) instead of :-.
