-module(server).
-import(translator,[translateTo_LTS/1]).
-compile(export_all).

start() -> spawn(server, loop, []).

comunicate(Server, AST) ->
   Ref = make_ref(),
   Server ! {lts, self(), Ref, AST},
   receive {response, Ref, Result} -> Result end.

loop() ->
   receive
       {lts, From, Ref, AST} ->
            From ! {response, Ref, translateTo_LTS(AST)}, 
            loop()
    end.