%% Neural Network Controller for Algorithm Optimization
:- dynamic nn_weight/3.
:- dynamic nn_threshold/2.

% Initialize neural network weights and thresholds
init_neural_network :-
    retractall(nn_weight(_,_,_)),
    retractall(nn_threshold(_,_)),
    % Simple neural network for controlling debug and execution flow
    assertz(nn_weight(debug_layer, 1, 0.7)),
    assertz(nn_weight(debug_layer, 2, 0.3)),
    assertz(nn_weight(execution_layer, 1, 0.6)),
    assertz(nn_weight(execution_layer, 2, 0.4)),
    assertz(nn_threshold(debug_layer, 0.5)),
    assertz(nn_threshold(execution_layer, 0.5)).

% Neural network decision function
nn_decide(Layer, Inputs, Decision) :-
    nn_threshold(Layer, Threshold),
    weighted_sum(Layer, Inputs, Sum),
    (Sum >= Threshold -> Decision = activate ; Decision = suppress).

weighted_sum(Layer, Inputs, Sum) :-
    findall(W*I, (member(I, Inputs), nn_weight(Layer, _, W)), Products),
    sumlist(Products, Sum).

%% Consolidated Debug Helper - replaces multiple predicate calls
debug_trace(CallType, Operation, Args, Variables) :-
    (   debug(on) ->
        (   nn_decide(debug_layer, [1, 0], Decision),
            (   Decision = activate ->
                debug_output(CallType, Operation, Args, Variables)
            ;   true
            )
        )
    ;   true
    ).

debug_output(call, Operation, Args, _Variables) :-
    writeln([call, [Operation|Args], "Press c."]),
    (not(get_single_char(97)) -> true ; abort).

debug_output(exit, Operation, Args, Variables) :-
    writeln([exit, [Operation, Variables|Args], "Press c."]),
    (not(get_single_char(97)) -> true ; abort).

interpretpart(is,Variable1,Value1,Vars1,Vars2) :-
        getvalue(Value1,Value1A,Vars1),
	%%isvalstr(Value1),
	%%isvalstr(Value1A),
	expression(Value1A),
        %%val1emptyorvalsequal(Value1A,Value1),
	%%isval(Value2),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable1,Value1A,Vars1,Vars2),
                debug_trace(call, is, [Value1A], variable),
                debug_trace(exit, is, [Value1A], Variable1)
            )
        ;   putvalue(Variable1,Value1A,Vars1,Vars2)
        ).
interpretpart(isplus,Variable1,Variable2,Variable3,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Variable3,Value1,Value2,Value3,Vars1),
        Value1A is Value2 + Value3,
        val1emptyorvalsequal(Value1,Value1A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable1,Value1A,Vars1,Vars2),
                debug_trace(call, is, [Value2+Value3], variable),
                debug_trace(exit, is, [Value2+Value3], Value1A)
            )
        ;   putvalue(Variable1,Value1A,Vars1,Vars2)
        ).
interpretpart(match,Variable1,Variable2,Variable3,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Variable3,Value1,Value2,Value3,Vars1),
        Value1 = [Value2A, Value3A],
        val1emptyorvalsequal(Value2,Value2A),
        val1emptyorvalsequal(Value3,Value3A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable2,Value2A,Vars1,Vars3),
                putvalue(Variable3,Value3A,Vars3,Vars2),
                debug_trace(call, =, [[Value2A, Value3A], [variable1,variable2]], _),
                debug_trace(exit, =, [[Value2A, Value3A]], [Value2A, Value3A])
            )
        ;   (   putvalue(Variable2,Value2A,Vars1,Vars3),
                putvalue(Variable3,Value3A,Vars3,Vars2)
            )
        ).
interpretpart(match,Variable1,Variable2,Variable3,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Variable3,Value1,Value2,Value3,Vars1),
        Value1A = [Value2, Value3],
        val1emptyorvalsequal(Value1,Value1A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable1,Value1A,Vars1,Vars2),
                debug_trace(call, =, [Value2,Value3], variable),
                debug_trace(exit, =, [[Value2,Value3]], [Value2,Value3])
            )
        ;   putvalue(Variable1,Value1A,Vars1,Vars2)
        ).
interpretpart(bracket1,Variable1,Variable2,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Value1,Value2,Vars1),
	Value1A = [Value2],
        val1emptyorvalsequal(Value1,Value1A),
        %%val1emptyorvalsequal(Value1A,Value2),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable1,Value1A,Vars1,Vars2),
                debug_trace(call, =, [Value2], variable),
                debug_trace(exit, =, [Value2], Variable2)
            )
        ;   putvalue(Variable1,Value1A,Vars1,Vars2)
        ).
interpretpart(bracket2,Variable1,Variable2,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Value1,Value2,Vars1),
        Value1A = Value2,
        val1emptyorvalsequal(Value1,Value1A),
        %%val1emptyorvalsequal(Value2A,Value1),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable1,Value1A,Vars1,Vars2),
                debug_trace(call, =, [Value2], [variable]),
                debug_trace(exit, =, [Value2], [Value2])
            )
        ;   putvalue(Variable1,Value1A,Vars1,Vars2)
        ).
interpretpart(head,Variable1,Variable2,Vars1,Vars2) :-
	getvalues(Variable1,Variable2,Value1,Value2,Vars1),
	Value1=[Value1A|_Rest],
        val1emptyorvalsequal(Value2,Value1A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable2,Value1A,Vars1,Vars2),
                debug_trace(call, head, [Value1,variable], _),
                debug_trace(exit, head, [Value1], Value1A)
            )
        ;   putvalue(Variable2,Value1A,Vars1,Vars2)
        ), !.
interpretpart(tail,Variable1,Variable2,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Value1,Value2,Vars1),
        Value1=[_Head|Value1A],
	%%removebrackets(Value1A,Value1B), 
        val1emptyorvalsequal(Value2,Value1A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable2,Value1A,Vars1,Vars2),
                debug_trace(call, tail, [Value1,variable], _),
                debug_trace(exit, tail, [Value1], Value1A)
            )
        ;   putvalue(Variable2,Value1A,Vars1,Vars2)
        ).
interpretpart(member,Variable1,Variable2,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Value1,Value2,Vars1),
	(   not(Value1=empty) ->
            (   nn_decide(execution_layer, [1, 0], Decision),
                Decision = activate ->
                (   member(Value1,Value2), Vars2=Vars1,
                    debug_trace(call, member, [Value1,Value2], _),
                    debug_trace(exit, member, [Value1,Value2], _)
                )
            ;   (member(Value1,Value2), Vars2=Vars1)
            )
        ;   (   nn_decide(execution_layer, [1, 0], Decision),
                Decision = activate ->
                (   member(Value3,Value2),
                    putvalue(Variable1,Value3,Vars1,Vars2),
                    debug_trace(call, member, [variable1,Value2], _),
                    debug_trace(exit, member, [Value3,Value2], _)
                )
            ;   (   member(Value3,Value2),
                    putvalue(Variable1,Value3,Vars1,Vars2)
                )
            )
        ).

interpretpart(delete,Variable1,Variable2,Variable3,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Variable3,Value1,Value2,Value3,Vars1),
        delete(Value1,Value2,Value3A),
        val1emptyorvalsequal(Value3,Value3A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable3,Value3A,Vars1,Vars2),
                debug_trace(call, delete, [Value1,Value2,variable3], _),
                debug_trace(exit, delete, [Value1,Value2], Value3A)
            )
        ;   putvalue(Variable3,Value3A,Vars1,Vars2)
        ).


interpretpart(append,Variable1,Variable2,Variable3,Vars1,Vars2) :-
        getvalues(Variable1,Variable2,Variable3,Value1,Value2,Value3,Vars1),
        append1(Value1,Value2,Value3A),
        val1emptyorvalsequal(Value3,Value3A),
        (   nn_decide(execution_layer, [1, 0], Decision),
            Decision = activate ->
            (   putvalue(Variable3,Value3A,Vars1,Vars2),
                debug_trace(call, append, [Value1,Value2,variable3], _),
                debug_trace(exit, append, [Value1,Value2], Value3A)
            )
        ;   putvalue(Variable3,Value3A,Vars1,Vars2)
        ).
getvalues(Variable1,Variable2,Value1,Value2,Vars) :-
        getvalue(Variable1,Value1,Vars),
        getvalue(Variable2,Value2,Vars).
getvalues(Variable1,Variable2,Variable3,Value1,Value2,Value3,Vars) :-
        getvalue(Variable1,Value1,Vars),
        getvalue(Variable2,Value2,Vars),
        getvalue(Variable3,Value3,Vars).
val1emptyorvalsequal(empty,Value) :-
	not(Value=empty).
val1emptyorvalsequal(Value,Value) :-
	not(Value=empty).
isop(is).
isop(=).
append1([],Item,Item) :-
	!.
append1(Item1,Item2,Item3) :-
	((isvalstr(Item1),Item1A=[Item1]);(not(isvalstr(Item1)),Item1A=Item1)),
        ((isvalstr(Item2),Item2A=[Item2]);(not(isvalstr(Item2)),Item2A=Item2)),
        %%((isvalstr(Item3),Item3A=[Item3]);(not(isvalstr(Item3)),Item3A=Item3)),
	append(Item1A,Item2A,Item3).
/**delete1(Item1,Item2,Item3) :-
	((isvalstr(Item1),Item1A=[Item1]);(not(isvalstr(Item1)),Item1A=Item1)),
        ((isvalstr(Item2),Item2A=[Item2]);(not(isvalstr(Item2)),Item2A=Item2)),
        %%((isvalstr(Item3),Item3A=[Item3]);(not(isvalstr(Item3)),Item3A=Item3)),
	delete(Item1A,Item2A,Item3).
**/

removebrackets([[Value]],Value) :-!.
removebrackets(Value,Value).
