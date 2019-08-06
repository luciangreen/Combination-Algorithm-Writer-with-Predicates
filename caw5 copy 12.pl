:- dynamic debug/1.

/**

caw00(off,function3,[],5,7,[[[[a,1],[b,1]],[[c,2]],true],[[[a,1],[b,1]],[[c,2]],true],[[[a,1],[b,1]],[[c,1]],fail],[[[a,1],[b,1]],[[c,1]],fail]],[],Program),writeln(Program).

VarLists is in format list of [InputVarList,OutputVarList,Positivity], where these are specification lines that are either Positivity=true or fail

Notes:
- true specification line in first position of varlists, otherwise will try all except the specification line
- manually write a,a in algdict in a,b :- a,a,b because cawp would take too long finding all combinations including a,a
- give argument values in order 3 2 1 not 1 2 3 when adding, or will try 1+1+1 instead of 3 at first

**/

:- include('algdict.pl').
:- include('remove_duplicate_predicates.pl').

caw00(Debug,PredicateName,Rules1,MaxLength,TotalVars,VarLists,Program1,Program2B) :-
	test(PredicatesA0),
	%% remove duplicate predicates
	remvdup(PredicatesA0,[],PredicatesA),
	split3(PredicatesA,[],Rules2),
	split2(PredicatesA,[],Predicates),
	%%writeln([Rules2,Predicates]),
	append(Rules1,Rules2,Rules3),

	retractall(debug(_)),
    	assertz(debug(Debug)),
	retractall(totalvars(_)),
    	assertz(totalvars(TotalVars)),
	VarLists=[VarLists1|VarLists2],
	findall(Program2A,caw0(Predicates,PredicateName,
		Rules3,MaxLength,
		VarLists1,Program1,Program2A),Program2),
	member(Program2B,Program2),
	aggregate_all(count,(member(Item,VarLists2),
	caw0(Predicates,PredicateName,Rules3,MaxLength,
		Item,Program1,Program2B)),Count),length(VarLists2,Count). %%Predicates->PredicatesA x

caw0(Algorithms,PredicateName,Rules,MaxLength,VarLists,Program1,Program2) :-
	VarLists=[InputVarList,OutputVarList,Positivity],
	varnames(InputVarList,[],InputVars,[],InputValues),
	varnames(OutputVarList,[],OutputVars,[],_OutputValues),
	retractall(outputvars(_)),
    	assertz(outputvars(OutputVars)),
append(InputVars,OutputVars,Vars11),
%%Vars11=InputVars,
%%Vars12=InputVars,
	append(InputValues,OutputVars,Vars2),
	%%append(InputValues,OutputValues,Values),
	Query=[[n,PredicateName],Vars2],
	caw(Algorithms,Query,PredicateName,Rules,MaxLength,Vars11,InputVars,InputVars,_,OutputVarList,OutputVars,Positivity,Program1,Program2).
caw(_,_,_,_,0,_,_,_,_,_,_,_,_,_) :- fail, !.
caw(Algorithms1,Query,PredicateName,_Rules,_MaxLength,_VarList,InputVars1,InputVars2,_InputVarsa,VarLists,OutputVars,Positivity,Program1,Program2) :-
	addrules(InputVars2,OutputVars,OutputVars,[],_PenultimateVars,[],Program3),
%%writeln([addrules(InputVars2,OutputVars,OutputVars,[],PenultimateVars,[],Program3)]),	
	%%optimise(Program1,InputVars1,_InputVars3,PenultimateVars,Program4), %% IV2->3
%%writeln([optimise(Program1,InputVars1,InputVars3,PenultimateVars,Program4)]),
	append(Program1,Program3,Program5),
	not(Program5=[]),
	append(InputVars1,OutputVars,Vars2),
	Program22=[
        [[n,PredicateName],Vars2,":-",
                Program5
        ]
        ],
	eliminate_unused_predicates(Program22,Algorithms1,Algorithms2),
	%%Algorithms2=[[[n,_],_,_,Body]|_],length(Body,1),
	%%(Program22=[[[n,function0],[[v,a],[v,b],[v,c]],":-",[[[n,function2],[[v,a],[v,b],[v,d]]],[[n,=],[[v,c],[v,d]]]]]]->writeln(eliminate_unused_predicates(Program22,Algorithms1,Algorithms2));true),
	
	append(Program22,Algorithms2,Program2),
	debug(Debug),
	%%writeln([program2,Program2]),
	%%writeln(["Press c."]),(get_single_char(97)->true;true),
%%writeln([interpret(Debug,Query,Program2,OutputVarList)]),
	%%writeln(interpret(Debug,Query,Program2,VarLists)),
	%%interpret(Debug,Query,Program2,OutputVarList).
	%%aggregate_all(count,(member(Item,VarLists),
	(Positivity=true->
	interpret(Debug,Query,Program2,VarLists);
	not(interpret(Debug,Query,Program2,VarLists))),!.%%),Count),
	%%length(OutputVarList,Count),!.
caw(Algorithms,Query,PredicateName,Rules,MaxLength,VarList,InputVars1,InputVars2,InputVars3,VarLists,OutputVars,Positivity,Program1,Program4) :-
%%writeln([caw(Query,PredicateName,Rules,MaxLength,VarList,InputVars1,InputVars2,OutputVarList,OutputVars,Program1,Program4)]),
	MaxLength2 is MaxLength - 1,
	%%reverse(InputVars2,InputVars5),

%%writeln(["ml",MaxLength2]),
	member([RuleName,NumInputs,NumOutputs],Rules),
%%writeln([member([RuleName,NumInputs,NumOutputs],Rules)]),
%%writeln([rule(RuleName,NumInputs,NumOutputs,VarList,VarList2,Rule)]),
	rule(RuleName,NumInputs,NumOutputs,InputVars2,InputVars4,VarList,VarList2,Rule), %% InputVars5->InputVars2
%%writeln([rule(RuleName,NumInputs,NumOutputs,InputVars1,InputVars3,VarList,VarList2,Rule)]),
	%%writeln(not(member(Rule,Program1))),
	not(member(Rule,Program1)),
	append(Program1,[Rule],Program3),
%%writeln([inputVars3,InputVars3]),
%%InputVars2=InputVars3,
%%writeln([program4,Program4]),
	caw(Algorithms,Query,PredicateName,Rules,MaxLength2,VarList2,InputVars1,InputVars4,InputVars3,VarLists,OutputVars,Positivity,Program3,Program4).

varnames([],Vars,Vars,Values,Values) :- !.
varnames(VarList,Vars1,Vars2,Values1,Values2) :-
	VarList=[Var|Vars3],
	Var=[VarName,Value],
	append(Vars1,[VarName],Vars4),
	append(Values1,[Value],Values3),
	varnames(Vars3,Vars4,Vars2,Values3,Values2),!.

addrules(_,_,[],PV,PV,Program,Program) :- !.
addrules(VarList,OutputVars1,OutputVars2,PenultimateVars1,PenultimateVars2,Program1,Program2) :-
	OutputVars2=[OutputVar|OutputVars3],
	member(Var,VarList),
	member(OutputVar,OutputVars1),
	append(Program1,[[[n,=],[OutputVar,Var]]],Program3),
	append(PenultimateVars1,[Var],PenultimateVars3),
	addrules(VarList,OutputVars1,OutputVars3,PenultimateVars3,PenultimateVars2,Program3,Program2).

%% optimise([[append,[a,a,d]],[append,[a,a,e]],[append,[a,a,f]],[append,[a,b,g]]],[g],P).

optimise(Program1,InputVars1,InputVars2,PenultimateVars,Program2) :-
	findrulesflowingtopv1(Program1,InputVars1,InputVars2,PenultimateVars,[],Rules,true),
	%%findrulesflowingtopv1a(Program1,_Program32,InputVars1,InputVars2,PenultimateVars,[],_Rules1),
	intersection(Program1,Rules,Program3),
	unique1(Program3,[],Program2).
findrulesflowingtopv1(_,_,_,[],Rules,Rules,false).
findrulesflowingtopv1(Program0,InputVars1,InputVars2,Var,Rules1,Rules2,IV1Flag1) :-
	(Var=[v,_]),%%***;length(Var,1)),
	findrulesflowingtopv20(Program0,Program0,InputVars1,InputVars2,Var,Rules1,Rules2,IV1Flag1).
findrulesflowingtopv1(Program0,InputVars1,InputVars2,Vars1,Rules1,Rules2,IV1Flag1) :-
	Vars1=[Var|Vars2],
	findrulesflowingtopv20(Program0,Program0,InputVars1,InputVars2,Var,Rules1,Rules3,IV1Flag2), 
	findrulesflowingtopv1(Program0,InputVars1,InputVars2,Vars2,Rules3,Rules2,IV1Flag3),
	iv1flagdisjunction(IV1Flag2,IV1Flag3,IV1Flag1).

%%findrulesflowingtopv2([],Program,Program,_,_,Rules,Rules).
findrulesflowingtopv20(_,[],_InputVars1,_InputVars2,_Var,Rules,Rules,false).
findrulesflowingtopv20(Program0,Rules4,InputVars1,InputVars2,Var,Rules1,Rules2,IV1Flag1) :-
	Rules4=[Rule|Rules],
	(findrulesflowingtopv2(Program0,Rule,InputVars1,InputVars2,Var,Rules1,Rules3,IV1Flag2)->true;(Rules3=Rules1,IV1Flag2=false)),
	%%delete(Program0,Rule,Program1),
	findrulesflowingtopv20(Program0,Rules,InputVars1,InputVars2,Var,Rules3,Rules2,IV1Flag3),%%p1->0
	iv1flagdisjunction(IV1Flag2,IV1Flag3,IV1Flag1).
%%findrulesflowingtopv2(_,[],[],_,_,_,Rules,Rules).
findrulesflowingtopv2(Program0,Rule,InputVars1,InputVars2,Var,Rules1,Rules2,IV1Flag1) :-
	Rule=[[n,_PredicateName],Vars],
	restlast(Vars,[],Rest,Var),
	%%delete(Program1,[PredicateName,Vars],Program2),
	%%Program2=Program1,
	%%(not(intersection(Rulesx,Rules1))-> x
	%% append, append, unique1
	%%append(Rules1,[Rule],Rules3);Rules3=Rules1),

	%%member(Var2,Rest),
	%%member(Var2,InputVars1),

	length(Rest,Length1), Length1>=1,
	subtract(Rest,InputVars1,IV3s),
	length(IV3s,Length3),
	subtract(Rest,IV3s,IV1s),
	length(IV1s,Length2), Length2>=1,
	subtract(IV3s,InputVars2,[]),

	IV1Flag2=true,

	%%delete(Program0,Rule,Program1),

	%%(delete(Program0,Rule,Program3),
	%%iv3s1(IV3s,Program3,IV3s,[]),
	(Length3>=1->
	(findrulesflowingtopv1(Program0,InputVars1,InputVars2,IV3s,[],Rules5,IV1Flag3),not(Rules5=[]));
	(Rules5=[],IV1Flag3=false)),
	iv1flagdisjunction(IV1Flag2,IV1Flag3,IV1Flag4),
	%%->true; Rules5=[],IV1Flag1=IV1Flag4),
	
	((findrulesflowingtopv1(Program0,InputVars1,InputVars2,IV1s,[],Rules6,IV1Flag5), %%iv1s->rest, etc
	iv1flagdisjunction(IV1Flag4,IV1Flag5,IV1Flag1))->true;(Rules6=[],IV1Flag1=IV1Flag4)),

	append([Rule],Rules1,Rules9),
	append(Rules9,Rules5,Rules7),
	append(Rules7,Rules6,Rules8),
	unique1(Rules8,[],Rules2).
	

/**
findrulesflowingtopv2(_Program0,Rule,InputVars1,InputVars2,Var,Rules1,Rules2,IV1Flag1) :-
	Rule=[_PredicateName,Vars],
	restlast(Vars,[],Rest,Var),
	%%delete(Program1,[PredicateName,Vars],Program2),
	%%Program2=Program1,
	(not(member(Rule,Rules1))->
	append(Rules1,[Rule],Rules2);Rules2=Rules1),
	subset(Rest,InputVars2),

	intersection(Rest,InputVars1,Intersection),
	length(Intersection,0),

%%	not((member(Var2,Rest),
%%	member(Var2,InputVars1))),

	IV1Flag1=false.
**/
/**
findrulesflowingtopv2(Program0,Rule,InputVars1,InputVars2,Var,Rules1,Rules2,IV1Flag1) :-
	Rule=[_PredicateName,Vars],
	restlast(Vars,[],Rest,Var),	
	%%delete(Program1,[PredicateName,Vars],Program3),
	%%Program3=Program1,
	%%append(Rules1,[Rule],Rules3),
	subset(Rest,InputVars2),
	
	intersection(Rest,InputVars1,Intersection),
	length(Intersection,0),

%%	not((member(Var2,Rest),
%%	member(Var2,InputVars1))),

%%	delete(Program0,Rule,Program1),

	IV1Flag2=false,
	findrulesflowingtopv1(Program0,InputVars1,InputVars2,Rest,[],Rules4,IV1Flag3),
	%%not(Rules4=[]),
	iv1flagdisjunction(IV1Flag2,IV1Flag3,IV1Flag1),

	append(Rules1,[Rule],Rules7),
	append(Rules7,Rules4,Rules8),
	unique1(Rules8,[],Rules2).
**/
/**
%%->true;(Program2=Program1,Rules2=Rules1)).
findrulesflowingtopv2(Rule,Program0,Program1,_Program2,InputVars1,InputVars,Var,Rules1,Rules2,IV1Flag1) :-
	Rule=[PredicateName,Vars],
	restlast(Vars,[],Rest,Var),
	%%delete(Program1,[PredicateName,Vars],Program4),
	%%Program4=Program1,
	append(Rules1,[[PredicateName,Vars]],Rules3),
	findrulesflowingtopv1(Program0,Program1,_Program2,InputVars1,InputVars,Rest,Rules3,Rules2,IV1Flag3),
	iv1flagdisjunction(IV1Flag2,IV1Flag3,IV1Flag1).

	%%findrulesflowingtopv2(Program5,Program2,Rest,Rules3,Rules2).

**/
iv1flagdisjunction(A,B,true) :-
	(A=true); (B=true).
iv1flagdisjunction(_,_,false).
/**
iv3s0([],_,IV3s1,IV3s2).
iv3s0(IV3s,Program0,IV3s1,IV3s2).
	IV3s=[IV3|IV3s3],
	iv3s1(IV3,Program0,IV3s1,IV3s4),
	iv3s0(IV3s3,Program0,IV3s4,IV3s2).
iv3s1(_,[],IV3s,IV3s).	
iv3s1(IV3,Program0,IV3s1,IV3s2) :-
	Program0=[Rule|Rules],
	iv3s2(IV3,Rule,IV3s1,IV3s3),
	iv3s1(IV3,Rules,IV3s3,IV3s2).
iv3s2(IV3,Rule,IV3s,IV3s1,IV3s2).
	Rule=[_PredicateName,Vars],
	restlast(Vars,[],_Rest,IV3),	
	delete(IV3s1,IV3,IV3s2).


findrulesflowingtopv1a(_,_,_,_,[],Rules,Rules).
findrulesflowingtopv1a(Program1,Program2,InputVars1,InputVars2,Var,Rules1,Rules2) :-
	atom(Var),
	findrulesflowingtopv2a(Program1,Program2,InputVars1,InputVars2,Var,Rules1,Rules2).
findrulesflowingtopv1a(Program1,Program2,InputVars1,InputVars2,Vars1,Rules1,Rules2) :-
	Vars1=[Var|Vars2],
	findrulesflowingtopv2(Program1,Program3,InputVars1,InputVars2,Var,Rules1,Rules3),
	findrulesflowingtopv1a(Program3,Program2,InputVars1,InputVars2,Vars2,Rules3,Rules2).
%%findrulesflowingtopv2([],Program,Program,_,_,Rules,Rules).
findrulesflowingtopv2a([],[],_,_,_,Rules,Rules).
findrulesflowingtopv2a(Program1,Program2,_InputVars1,InputVars2,Var,Rules1,Rules2) :-
	member([PredicateName,Vars],Program1),
	restlast(Vars,[],Rest,Var),
	(
%%delete(Program1,[PredicateName,Vars],Program2),
Program2=Program1,
	append(Rules1,[[PredicateName,Vars]],Rules2),
	subset(Rest,InputVars2)).
findrulesflowingtopv2a(Program1,Program2,InputVars1,InputVars2,Var,Rules1,Rules2) :-
	member([PredicateName,Vars],Program1),
	restlast(Vars,[],Rest,Var),
	(
%%delete(Program1,[PredicateName,Vars],Program3),
Program3=Program1,
	append(Rules1,[[PredicateName,Vars]],Rules3),
	subset(Rest,InputVars2)),
	findrulesflowingtopv1a(Program3,Program2,InputVars1,InputVars2,Rest,Rules3,Rules2).

%%->true;(Program2=Program1,Rules2=Rules1)).
findrulesflowingtopv2a(Program1,Program2,InputVars1,InputVars,Var,Rules1,Rules2) :-
	member([PredicateName,Vars],Program1),
	restlast(Vars,[],Rest,Var),
	%%delete(Program1,[PredicateName,Vars],Program4),
	Program4=Program1,
	append(Rules1,[[PredicateName,Vars]],Rules3),
	findrulesflowingtopv1a(Program4,Program2,InputVars1,InputVars,Rest,Rules3,Rules2).
	%%findrulesflowingtopv2(Program5,Program2,Rest,Rules3,Rules2).
	**/

restlast([],_,_,_) :- fail, !.	
restlast([Last],Rest,Rest,Last) :-
	Last=[v,_],!.
restlast(Last,Rest,Rest,Last) :-
	length(Last,1),!.
restlast(Vars1,Rest1,Rest2,Last) :-
	Vars1=[Var|Vars2],
	append(Rest1,[Var],Rest3),
	restlast(Vars2,Rest3,Rest2,Last),!.


rule(RuleName,InModes,OutModes,InputVars1,InputVars2,VarList,VarList2,Rule) :-
	get_members(InModes,InputVars1,[],Vars1),
	rulea(OutModes,RuleName,Vars1,VarList,VarList2,
		Rule,Vars2),
	restlast(InputVars1,[],_,Last),
	(equals_or(Vars1,Last)->true;equals_or(Vars2,Last)),
	append(InputVars1,Vars2,InputVars2),!.

member_functions(Rule,Algorithms,Item) :-
	member(Item,Algorithms),
	Item=[Rule|_Rest].

get_members(0,_InputVars,Vars,Vars):-!.
get_members(InModes1,InputVars,Vars1,Vars2) :-
	member(Var,InputVars),
	append(Vars1,[Var],Vars3),
	InModes2 is InModes1-1,
	get_members(InModes2,InputVars,Vars3,Vars2).

equals_or([],_) :- fail.
equals_or(List,Item) :-
	List=[Item|_Rest],!.
equals_or(List,Item1) :-
	List=[Item2|Rest],
	not(Item1=Item2),
	equals_or(Rest,Item1),!.

rulea(OutModes,RuleName,Vars1,VarList,VarList3,Rule,Vars2) :-
    get_vars(OutModes,VarList,VarList3,[],Vars2),
    append(Vars1,Vars2,Vars3),
    Rule=[RuleName,Vars3],!.

get_vars(0,VarList,VarList,Vars,Vars) :- !.
get_vars(OutModes1,VarList1,VarList2,Vars1,Vars2) :-
    var(VarList1,Var,VarList3),
    append(Vars1,[Var],Vars3),
    OutModes2 is OutModes1 - 1,
	 get_vars(OutModes2,VarList3,VarList2,Vars3,Vars2),!.
	
/**

rule(RuleName,1,1,InputVars1,InputVars2,VarList,VarList2,Rule) :-
	member(Var,InputVars1),
	rule2(RuleName,Var,VarList,VarList2,Rule,Var1),
	append(InputVars1,[Var1],InputVars2).
rule2(RuleName,Var,VarList,VarList2,Rule,Var1) :-
	var(VarList,Var1,VarList2),
	Rule=[RuleName,[Var,Var1]],!.

rule(RuleName,1,2,InputVars1,InputVars2,VarList,VarList2,Rule) :-
        member(Var,InputVars1),
        rule3(RuleName,Var,VarList,VarList2,Rule,Vars),
	append(InputVars1,Vars,InputVars2).
rule3(RuleName,Var,VarList,VarList3,Rule,[Var1,Var2]) :-
        var(VarList,Var1,VarList2),
        var(VarList2,Var2,VarList3),
        Rule=[RuleName,[Var,Var1,Var2]],!.

rule(RuleName,2,1,InputVars1,InputVars2,VarList,VarList2,Rule) :-
        member(Var,InputVars1),
        member(Vara,InputVars1),
        rule4(RuleName,Var,Vara,VarList,VarList2,Rule,Var1),
	append(InputVars1,[Var1],InputVars2).
rule4(RuleName,Var,Vara,VarList,VarList2,Rule,Var1) :-
        var(VarList,Var1,VarList2),
        Rule=[RuleName,[Var,Vara,Var1]],!.

rule(RuleName,2,2,InputVars1,InputVars2,VarList,VarList2,Rule) :-
        member(Var,InputVars),
        member(Vara,InputVars),
        rule5(RuleName,Var,Vara,VarList,VarList2,Rule,Vars),
	append(InputVars1,Vars,InputVars2).
rule5(RuleName,Var,Vara,VarList,VarList3,Rule,[Var1,Var2]) :-
        var(VarList,Var1,VarList2),
        var(VarList2,Var2,VarList3),
        Rule=[RuleName,[Var,Vara,Var1,Var2]],!.

**/

%%var(Item,Var,Vars,Vars) :-
%%	member([Item,Var],Vars).
var(Vars1,Var1,Vars2) :-
	length(Vars1,Vars1Length1),
	Vars1Length2 is Vars1Length1-1,
	length(Vars3,Vars1Length2),
	append(Vars3,[Var2A],Vars1),
	Var2A=[v,Var2],
	char_code(Var2,Var2Code1),
	Var2Code2 is Var2Code1 + 1,
	var2(Var2Code2,Var1A),
	Var1=[v,Var1A],
	append(Vars1,[Var1],Vars2),!.

var2(Code,Var1) :-
	outputvars(OutputVars),
	totalvars(TotalVars),
	Code2 is 96+TotalVars,
	Code =< Code2, %% 122
	char_code(Var1,Code),
	not(member(Var1,OutputVars)),!.
var2(Var2Code,Code3) :-
	Var2Code2 is Var2Code + 1,	
	totalvars(TotalVars),
	Code2 is 96+TotalVars,
	Var2Code2 =< Code2,
	var2(Var2Code2,Code3),!.
/**
algorithmstopredicates1([],Predicates1,Predicates1) :-!.
algorithmstopredicates1(Algorithms1,Predicates1,Predicates2) :-
	Algorithms1=[Algorithm1|Algorithms2],
	Algorithm1=[_TestNumber,_Queries,Algorithm3],
	algorithmstopredicates2(Algorithm3,[],Algorithm4),
	append_list(Predicates1,Algorithm4,Predicates4),
	algorithmstopredicates1(Algorithms2,Predicates4,Predicates2).
algorithmstopredicates2([],Predicates1,Predicates1) :- !.
algorithmstopredicates2(Algorithms1,Predicates1,Predicates2) :-
	Algorithms1=[Algorithm1|Algorithms2],
	Algorithm1=[Name,In,Out|Rest],
	append(Predicates1,[[Name,In,Out|Rest]],Predicates4),
	algorithmstopredicates2(Algorithms2,Predicates4,
		Predicates2).
**/
split3([],List,List) :- !.
split3(Predicates1,List1,List2) :-
	Predicates1=[Item1|List4],
	Item1=	[[[n,Name],In,Out]|_Rest],
	append(List1,[[[n,Name],In,Out]],List6),
	split3(List4,List6,List2),!.
	
split2([],List,List) :- !.
split2(Predicates1,List1,List2) :-
	Predicates1=[Item1|List4],
	Item1=	[[[n,Name],_In,_Out]|Rest],
	append(List1,[[[n,Name]|Rest]],List6),
	split2(List4,List6,List2),!.

/**
split2([],List,List) :- !.
split2(Predicates1,List1,List2) :-
	Predicates1=[Item1|List4],
	Item1=[[n,[Name,[[test,Test1],[numin,Numin],
		[numout,Numout]]]]|Rest],
	member([[n,[Name,[[test,_Test3],[numin,Numin],
		[numout,Numout]]]]|Rest],List4),
	delete(List4,[[n,[Name,[[test,_Test4],[numin,Numin],
		[numout,Numout]]]]|Rest],
		List7),
	append(List1,[[[n,[Name,[[test,Test1],[numin,Numin],
		[numout,Numout]]]]|Rest]],List6),
	split2(List7,List6,List2),!.
split2(Predicates1,List1,List2) :-
	Predicates1=[Item1|List4],
	Item1=[[n,[Name,[[test,Test1],[numin,Numin],
		[numout,Numout]]]]|Rest],
	append(List1,[[[n,[Name,[[test,Test1],[numin,Numin],
		[numout,Numout]]]]|Rest]],List6),
	split2(List4,List6,List2),!.
	
append_list(A,[],A):-!.
append_list(A,List,B) :-
	List=[Item|Items],
	append(A,[Item],C),
	append_list(C,Items,B).

**/

eliminate_unused_predicates(Program1a,Algorithms1a,Algorithms2) :-
	%% System calls and mode arities
	%%System_calls=[[is,1,1],[+,2,1],[=,2,1],[wrap,1,1],
	%%[unwrap,1,1],[head,1,1],[tail,1,1],[member,1,1],
	%%[delete,2,1],[append,2,1]], %% Ignore whether system calls are in Program and Algorithm - the interpreter will have detected whether system and user predicates clash earlier

	Program1a=[[[n, PredicateName], Arguments, ":-", _Body]],
	length(Arguments,ArgumentsLength),
	Start=[[[n,PredicateName],ArgumentsLength]],
		convert_to_grammar_part1(Program1a,[],_Program1b,Program1),
	%% Find calls in Program
	%%writeln([program1,Program1]),
	find_calls1(Start,Program1,[],Program2),
	%%writeln([program2,Program2]),
	%% Find calls in Algorithm
		convert_to_grammar_part1(Algorithms1a,[],_Algorithms1b,Algorithms1),
	%%writeln([algorithms1,Algorithms1]),
	find_calls1(Program2,Algorithms1,[],Algorithms3),
	%%writeln([algorithms3,Algorithms3]),
	append(Program2,Algorithms3,Rules),
	%% Eliminate user predicates mentioned in Program and Algorithms in Algorithms 
	eliminate_unused_predicates1(Rules,Algorithms1,[],
		Algorithms2).
	
find_calls1(_,[],Program,Program) :- !.
find_calls1(Program0,Program1,Program2,Program3) :-
	Program1=[[_Program4a,Program4]|Program5],
	%% The first predicate in Program4 only is needed to find the calls x
	(findall(Program7a,(((member([[n,PredicateName],Arguments,":-",Program6],Program4)->true;((member([[n,PredicateName],Arguments],Program4),Program6=[])->true;Program4=[[n,PredicateName],Arguments,":-",Program6])),
	length(Arguments,ArgumentsLength),
	Item=[[n,PredicateName],ArgumentsLength],
	(member(Item,Program0)->Program6=Program6a;Program6a=[])%%->true;
	%%Item=Program0
	),
	(find_calls2(Program6a,[],Program7a))),[Program7])),
	%%append(Program2,Program7,Program8),
	%%append(Program0,Program7,Program01));
	%%(Program8=Program2,Program01=Program0)),
	append(Program2,Program7,Program8),
	append(Program0,Program7,Program01),
	find_calls1(Program01,Program5,Program8,Program3).
	
find_calls2([],Program,Program) :- !.
/**
find_calls2(Program1,Program2,Program3) :-
	Program1=[Line|Program41],
	Line=[[n,code]|Program42],
	find_calls2(Program41,Program2,Program5),
	append(Program5,Program42,Program6),
	find_calls2(Program6,[],Program3).
**/

find_calls2(Program1,Program2,Program3) :-
	Program1=[Line|Program4],
	(Line=[[n,PredicateName],Arguments]->
	length(Arguments,ArgumentsLength);
	(Line=[[n,PredicateName]],ArgumentsLength=0)), %% correct syntax is [true] not true
	Item=[[[n,PredicateName],ArgumentsLength]],
	append(Program2,Item,Program5),
	find_calls2(Program4,Program5,Program3).

eliminate_unused_predicates1(_Rules,[],Algorithms,Algorithms) :- !.
eliminate_unused_predicates1(Rules,Algorithms1,Algorithms2,Algorithms3) :-
	Algorithms1=[[Algorithms4a,Algorithms4]|Algorithms5],
	%%(Algorithms4a=[]->
		%%eliminate_unused_predicates1(Rules,Algorithms5,Algorithms2,
		%%Algorithms3),%%;
((findall(Algorithms6a,(((member(Algorithms4a1,Algorithms4),Algorithms4a1=[[n,_]|_])->true;Algorithms4a1=Algorithms4),	((Algorithms4a1=[[n,PredicateName],Arguments,":-",_Program6],
%%Algorithms4a1=[[n,PredicateName],Arguments])->
	length(Arguments,ArgumentsLength))->true;
	(Algorithms4a1=[[n,PredicateName],Arguments2],
		length(Arguments2,ArgumentsLength)->true;
		(Algorithms4a1=[[n,PredicateName]],ArgumentsLength=0))),
	Item=[[n,PredicateName],ArgumentsLength],
	(member(Item,Rules)->
		(Algorithms4a=[]->Algorithms2=Algorithms6a;
		append(Algorithms2,
		[Algorithms4a],Algorithms6a));
		Algorithms6a=Algorithms2)),Algorithms6b)),
		Algorithms6b=[Algorithms6c|_],
		(var(Algorithms6c)->Algorithms6=[];Algorithms6=Algorithms6c),
		%%length(Algorithms4,Count)),
	eliminate_unused_predicates1(Rules,Algorithms5,Algorithms6,
		Algorithms3)).
