-module(sum).
-export([sum/2, start/0]).

%sum(Total) -> sum(Total, 0);
sum(0, Total) -> Total;
sum(N, Total) -> sum(N - 1, Total + N).

start() ->
    Start = now(),
    Result = sum(10000000, 0),
    End = now(),
    io:format("~B~n", [Result]),
    io:format("~f~n", [timer:now_diff(End, Start) / 1000000]).
