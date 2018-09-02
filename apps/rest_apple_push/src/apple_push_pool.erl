%%%-------------------------------------------------------------------
%%% @author Adinarayana
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Sep 2018 5:04 PM
%%%-------------------------------------------------------------------
-module(apple_push_pool).
-author("Adinarayana").

%% API
-export([ start/0
  , push/2
]).


start() ->
  push_pool_sup:start_link(?MODULE).

push(DeviceId, Msg) ->
  Notification = prepare_notification(Msg),
  Topic = <<"com.xyz.myapp">>, % Replace with your own topic
  wpool:call(?MODULE, {push, DeviceId, Topic, Notification}).

%%%===================================================================
%%% private functions
%%%===================================================================

prepare_notification(Msg) ->
  #{<<"aps">> => #{ <<"alert">> => Msg, <<"sound">> => <<"default">>, <<"badge">> => 1} }.


