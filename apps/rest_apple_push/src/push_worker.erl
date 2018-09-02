%%%-------------------------------------------------------------------
%%% @author Adinarayana
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Sep 2018 5:33 PM
%%%-------------------------------------------------------------------
-module(push_worker).
-author("Adinarayana").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init(Config) ->
  {ok, Conn} = apns:connect(Config),
  {ok, #{conn_pid => Conn}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%%--------------------------------------------------------------------

handle_call({push, DeviceId, Topic, Notif}, _From, State) ->
  #{conn_pid := Conn} = State,
  Headers = #{apns_topic => Topic},
  Response = apns:push_notification(Conn, DeviceId, Notif, Headers),
  {reply, Response, State};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
