
%% cawptest(Debug[on/off],Total,Score).

cawptest(Debug,NTotal,Score) :- cawptest(Debug,0,NTotal,0,Score),!.
cawptest(_Debug,NTotal,NTotal,Score,Score) :- NTotal=2, !.
cawptest(Debug,NTotal1,NTotal2,Score1,Score2) :-
	NTotal3 is NTotal1+1,
	cawptest2(NTotal3,Specifications,Program),
	(caw00(Debug,function0,[],5,7,Specifications,[],Program)->(Score3 is Score1+1,writeln([cawptest,NTotal3,passed]));(Score3=Score1,writeln([cawptest,NTotal3,failed]))),
	writeln(""),
	cawptest(Debug,NTotal3,NTotal2,Score3,Score2),!.

cawptest1(Debug,N,Passed) :-
	cawptest2(N,Specifications,Program),
	(caw00(Debug,function0,[],5,7,Specifications,[],Program)->(Passed=passed,writeln([cawptest,N,passed]));(Passed=failed,writeln([cawptest,N,failed]))),!.


cawptest2(1,[[[[[v,a],1],[[v,b],1]],[[[v,c],3]],true]],
		
[[[n,function0],[[v,a],[v,b],[v,c]],":-",
	[[[n,function2],[[v,a],[v,b],[v,d]]],
	[[n,=],[[v,c],[v,d]]]]],
[[n,function2],[[v,a],[v,b],[v,c]],":-",
	[[[n,+],[[v,a],[v,b],[v,d]]],
	[[n,+],[[v,d],1,[v,c]]]]]]).


cawptest2(2,[[[[[v,a],1],[[v,b],1]],[[[v,c],2]],true],[[[[v,a],1],[[v,b],2]],[[[v,c],3]],true],[[[[v,a],1],[[v,b],1]],[[[v,c],1]],fail],[[[[v,a],1],[[v,b],1]],[[[v,c],3]],fail]],

[[[n,function0],[[v,a],[v,b],[v,c]],":-",
	[[[n,function1],[[v,a],[v,b],[v,d]]],
	[[n,=],[[v,c],[v,d]]]]],
[[n,function1],[[v,a],[v,b],[v,c]],":-",
	[[[n,+],[[v,a],[v,b],[v,c]]]]]]).

