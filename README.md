# Combination-Algorithm-Writer-with-Predicates

Combination-Algorithm-Writer-with-Predicates readme

Combination Algorithm Writer with Predicates
Combination Algorithm Writer with Predicates is a SWI-Prolog algorithm that finds combinations of predicates (in algdict.pl) that satisfy the given input and output.

# Getting Started

Please read the following instructions on how to install the project on your computer for writing code.

# Prerequisites

Install List Prolog Interpreter Repository (https://github.com/luciangreen/listprologinterpreter) first.

# Installing

* Download this repository.
* In SWI-Prolog, enter:
```
['cawplistprolog'].
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
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,function1],[[v,a],[v,b],[v,d]]],[[n,function1],[[v,a],[v,d],[v,e]]],[[n,=],[[v,c],[v,e]]]]],[[n,function1],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,c]]]]]]`

Example
`caw00(off,f,[[append,2,1],[delete,2,1],[head,1,1],[tail,1,1],[member,1,1]],3,5,[[[[[v,a],1]],[[[v,b],1]],true]],[],Program),writeln(Program).`

Example Output
`[[[n,f],[[v,a],[v,b]],:-,[[[n,=],[[v,b],[v,a]]]]]]`


Example
`caw00(off,function3,[[[n,+],2,1]],5,7,[[[[[v,a],1],[[v,b],1]],[[[v,c],3]],true]],[],Program),writeln(Program).`

Example Output
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,d]]],[[n,+],[[v,a],[v,d],[v,e]]],[[n,=],[[v,c],[v,e]]]]]]`


Example
`caw00(off,function3,[[[n,+],2,1],[[n,*],2,1]],5,7,[[[[[v,a],2],[[v,b],2]],[[[v,c],4]]]],[],Program),writeln(Program).`

Example Output
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,d]]],[[n,=],[[v,c],[v,d]]]]]]`
and
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,*],[[v,a],[v,b],[v,d]]],[[n,=],[[v,c],[v,d]]]]]]`


Example
`caw00(off,function3,[[[n,+],2,1],[[n,*],2,1]],5,7,[[[[[v,a],2],[[v,b],2]],[[[v,c],4]],true],[[[[v,a],1],[[v,b],1]],[[[v,c],2]],fail]],[],Program),writeln(Program).`

Example Output
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,*],[[v,a],[v,b],[v,d]]],[[n,=],[[v,c],[v,d]]]]]]`


You can enter a partially complete predicate as the second last argument and the algorithm will complete the algorithm if possible:
Example
`caw00(off,function3,[],5,7,[[[[[v,a],1],[[v,b],1]],[[[v,c],3]],true]],[[[n,=],[[v,a],[v,b]]]],Program),writeln(Program).`
Example Output
`[[[n,function3],[[v,a],[v,b],[v,c]],:-,[[[n,=],[[v,a],[v,b]]],[[n,function1],[[v,a],[v,b],[v,d]]],[[n,function1],[[v,a],[v,d],[v,e]]],[[n,=],[[v,c],[v,e]]]]],[[n,function1],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,c]]]]]]`


Try CAWP regression tests (in cawpverify.pl):
Example
`cawptest(off,N,S).`
Example Output
```
[cawptest,1,passed]

[cawptest,2,passed]

N = S, S = 2.
```

Use RCAWP (Random Combination Algorithm Writer with Predicates) to generate random algorithms with predicates.
Example
```
['meditationnoreplace'].
N is 1, rcawp1(N).
```
Example Output
```
[[[n,function0],[[v,a],[v,b],[v,c]],:-,[[[n,function1],[[v,a],[v,b],[v,d]]],[[n,=],[[v,c],[v,d]]]]],[[n,function1],[[v,a],[v,b],[v,c]],:-,[[[n,+],[[v,a],[v,b],[v,c]]]]]]

...trace of algorithm...

% 2,725,280 inferences, 1.772 CPU in 1.936 seconds (92% CPU, 1537945 Lips)
[./rcawp20197211823.txt,not t2b2'ed out.  Please do manually.]
```

**Note:**

Use ":-" instead of :-.

# Versioning

We will use SemVer for versioning.

# Authors

Lucian Green - Initial programmer - <a href="https://www.lucianacademy.com/">Lucian Academy</a>

# License

I licensed this project under the BSD3 License - see the <a href="LICENSE">LICENSE.md</a> file for details

