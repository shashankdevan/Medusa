-module(frequency).
-export([start/0]).

start() ->
    Packet = "...Heytretrrrrrrrrrrrrrrr$%$#?? you good you you terminal, Happy Thanksgiving!",
    Packet2 = "good terminal when is Thanksgiving!",
    Dict1 = create_dictionary(Packet),
    Dict2 = create_dictionary(Packet2),
    MergedDict = merge(Dict1, Dict2),
    print_dict(Dict1),
    print_dict(Dict2),
    print_dict(MergedDict),
    find_most_frequent(MergedDict).


merge(Dict1, Dict2) ->
    dict:fold(fun(K2, V2, D1) ->
                      case (dict:find(K2, D1)) of
                          {ok, _} -> dict:update(K2, fun(V1) -> V1 + V2 end, D1);
                          error -> D1
                      end
              end, Dict1, Dict2).


create_dictionary(Packet) ->
    Tokens = string:tokens(Packet, " "),
    lists:foldl(fun(Word, Dict) ->
                        {match, [{Start, Length}]} = re:run(Word, "[a-zA-Z]+"),
                        RefinedWord = string:substr(Word, Start+1, Length),
                        dict:update(RefinedWord, fun(Count) -> Count + 1 end, 1, Dict)
                end, dict:new(), Tokens).


find_most_frequent(Dict) ->
    {MaxKey, MaxValue} = dict:fold(fun(K, V, {MaxKey, MaxValue}) ->
                                           case (V > MaxValue) of
                                               true -> {K, V};
                                               false -> {MaxKey, MaxValue}
                                           end
                                   end, {non_existing_key, 0}, Dict),
    io:format("Maximum = ~s : ~B~n", [MaxKey, MaxValue]).


print_dict(Dict) ->
    dict:fold(fun(Word, Count, AccIn) ->
                      io:format("~s: ~w~n", [Word, Count]),
                      AccIn
              end, void, Dict),
    io:format("------------------~n").
