% Test file to demonstrate neural network controlled improvements
:- ['lpi_caw_commands.pl'].
:- ['listprologinterpreter1listrecursion4copy52.pl'].
:- ['listprologinterpreter3preds5copy52.pl'].
:- ['caw5copy11.pl'].

% Test the neural network functionality
test_neural_network :-
    init_neural_network,
    nn_decide(debug_layer, [1, 0], Decision1),
    nn_decide(execution_layer, [1, 0], Decision2),
    writeln(['Neural Network Decisions:', debug_layer=Decision1, execution_layer=Decision2]).

% Test the improved CAW algorithm
test_improved_caw :-
    writeln('Testing improved Combination Algorithm Writer with Neural Network control...'),
    test_neural_network,
    writeln('Running CAW algorithm...'),
    caw00(off,f,[[+,2,1]],4,8,[[a,1],[b,1],[c,2],[d,1]],[[e,5]],[[[f1,4,1],[a,b,c,d,e],(:-),[[+,[a,b,f]],[+,[c,f,g]],[+,[d,g,h]],[=,[e,h]]]]],[],P),
    writeln('Algorithm completed successfully with result:'),
    writeln(P).

% Run the test
:- initialization(test_improved_caw).