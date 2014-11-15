
-module(twitter_util).
-author("Yuce Tekol").

-export([make_url/1, get_timestamp/0]).
-export([save_term/2, load_term/1]).

-include("util.hrl").
-include("def.hrl").


-spec make_url({scheme(), host(), path(), query_string()}) -> url()
    ; ({scheme(), string(), host(), integer(), path(), query_string()})
         -> url()
    ; ({url(), path(), query_string()}) -> url()
    ; ({url(), query_string()}) ->url().

make_url({Scheme, Host, Path, QueryString}) ->
    make_url({Scheme, "", Host, 0, Path, QueryString});

make_url({Scheme, _UserInfo, Host, _Port, Path, QueryString}) ->
    BaseUrl = lists:concat([Scheme, "://", Host]),
    make_url({BaseUrl, Path, QueryString});

make_url({BaseUrl, Path, QueryString}) ->
    Path0 = string:left(Path, 1),
    NormPath = ?select(Path0 == "/", Path, lists:append("/", Path)),
    make_url({lists:append(BaseUrl, NormPath), QueryString});

make_url({BaseUrl, QueryString}) ->
    NormQS = ?select(QueryString == "", "",
        lists:append("?", QueryString)),
    lists:append(BaseUrl, NormQS).


-spec get_timestamp() -> seconds().

get_timestamp() ->
    {Mega, Sec, _} = os:timestamp(),
    Mega * 1000000 + Sec.


-spec save_term(path(), term()) -> ok | {error, term()}.

save_term(Path, Term) ->
    file:write_file(Path, io_lib:fwrite("~p.~n", [Term])).


-spec load_term(path()) -> term().

load_term(Path) ->
    {ok, [Term|_]} = file:consult(Path),
    Term.

