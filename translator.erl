-module(translator).
-import(string,[concat/2]).
-compile(export_all).

member(_, []) -> false;
member(Element, [Element|_]) -> true;
member(Element, [_|Tail]) -> member(Element, Tail).

%Simple Function to add if not already present
addToList(Element, List) ->
    Member = member(Element,List),
    if
        Member == false ->
            NewList = List ++ [Element];
        true -> 
            NewList = List
    end,
    NewList.

%Generate a list of states based on the transitions's List
get_states([], List) -> List;
get_states([{S1,_,S2}|Tail], List) ->
    NewList = addToList(S1, List),
    NewList1 = addToList(S2, NewList),
    get_states(Tail, NewList1).

%Get the name of the current AST Node and format the output string
get_name(AST) -> case AST of
    zero -> zero;
    {prefix, Action, zero} -> concat(Action, ".zero");
    {prefix, Action, NextAST} -> 
        Str = concat(Action, "."),
        concat(Str, get_name(NextAST));
    {choice, Left, Right} ->
        Str = concat("(", get_name(Left)),
        Str1 = concat(Str, " + "),
        Str2 = concat(Str1, get_name(Right)),
        concat(Str2, ")")
end.

%Basically the Main
translateTo_LTS(AST) ->
    Transitions = translateTo_LTS(AST, ""),
    States = get_states(Transitions, []),
    Initial = hd(States),
    LTS = {States, Transitions, Initial},
    io:fwrite("~p~n",[LTS]).
    %io:fwrite("~p~n",[Transitions]).

%Generate the list of Transtition based on the AST
translateTo_LTS(AST, UpperChoiceState) -> case AST of
    zero -> [];
    %Base case of Prefix
    {prefix, Action, zero} ->
        Str = concat(Action,"."),
        StateName = concat(Str,"zero"),
        if 
            UpperChoiceState == "" ->
                [{StateName, Action, zero}];
            true ->
                [{UpperChoiceState, Action, zero}]
        end;

    %General case of Prefix
    {prefix, Action, NextStateAST} ->
        NextState = translator:get_name(NextStateAST),
        Str = concat(Action,"."),
        StateName = concat(Str,NextState),
        if 
            UpperChoiceState == "" ->
                [{StateName, Action, NextState}] ++ translateTo_LTS(NextStateAST, NextState);
            true ->
                [{UpperChoiceState, Action, NextState}] ++ translateTo_LTS(NextStateAST, "")
        end;

    {choice, Left, Right} ->
        LeftStateName = concat(translator:get_name(Left), " + "),
        StateName = concat(LeftStateName, translator:get_name(Right)),
        if
            UpperChoiceState == "" ->
                LeftT = translateTo_LTS(Left, StateName),
                RightT = translateTo_LTS(Right, StateName);
            true ->
                LeftT = translateTo_LTS(Left, UpperChoiceState),
                RightT = translateTo_LTS(Right, UpperChoiceState)
        end,
        LeftT ++ RightT        
end.




