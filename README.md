# Combination-Algorithm-Writer-with-Predicates

Combination-Algorithm-Writer-with-Predicates readme

Combination Algorithm Writer with Predicates
Combination Algorithm Writer with Predicates is a SWI-Prolog algorithm that finds combinations of predicates (in algdict.pl) that satisfy the given input and output.

# Getting Started

Please read the following instructions on how to install the project on your computer for writing code.

# Prerequisites

None

# Installing

* Download this repository.
* In SWI-Prolog, enter:
```
['listprolog'].
```
* Running
Example
`caw00(off,function3,[],5,7,[[[[[v,a],1],[[v,b],1]],[[[v,c],2]],true],[[[[v,a],1],[[v,b],2]],[[[v,c],3]],true],[[[[v,a],1],[[v,b],1]],[[[v,c],1]],fail],[[[[v,a],1],[[v,b],1]],[[[v,c],3]],fail]],[],Program),writeln(Program).`

VarLists is in format list of [InputVarList,OutputVarList,Positivity], where these are specification lines that are either Positivity=true or fail.
Example Output
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,function1],[[v,a],[v,b],[v,d]]],[[n,=],[[v,c],[v,d]]]]],[[n,function1],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,c]]]]]]
`
Example
`caw00(off,function3,[],5,7,[[[[[v,a],1],[[v,b],1]],[[[v,c],3]],true]],[],Program),writeln(Program).`

Example Output
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,function1],[[v,a],[v,b],[v,d]]],[[n,function1],[[v,a],[v,d],[v,e]]],[[n,=],[[v,c],[v,e]]]]],[[n,function1],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,c]]]]]]
`

**Note:**

Use ":-" instead of :-.

# Versioning

We will use SemVer for versioning.

# Authors

Lucian Green - Initial programmer - <a href="https://www.lucianacademy.com/">Lucian Academy</a>

# License

I licensed this project under the BSD3 License - see the <a href="LICENSE">LICENSE.md</a> file for details

