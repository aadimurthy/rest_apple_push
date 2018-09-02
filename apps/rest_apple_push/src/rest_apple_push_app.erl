%%%-------------------------------------------------------------------
%% @doc rest_apple_push public API
%% @end
%%%-------------------------------------------------------------------

-module(rest_apple_push_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->

    { ok, Pid} = 'rest_apple_push_sup':start_link(),
    Routes = [ {
        '_',
        [
            {"/sendnotification/:device_id", push_api_handler, []}
        ]
    } ],
    Dispatch = cowboy_router:compile(Routes),

    NumAcceptors = 10,
    TransOpts = [ {ip, {0,0,0,0}}, {port, 8080} ],
    ProtoOpts = [{env, [{dispatch, Dispatch}]}],
    %{ok,_}  = apple_push_pool:start(),
    {ok, _} = cowboy:start_http(rest_apns,
        NumAcceptors, TransOpts, ProtoOpts),

    {ok, Pid}.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
