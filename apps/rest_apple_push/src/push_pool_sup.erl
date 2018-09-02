%%%-------------------------------------------------------------------
%%% @author Adinarayana
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Sep 2018 5:25 PM
%%%-------------------------------------------------------------------
-module(push_pool_sup).
-author("Adinarayana").

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================


start_link(PoolName) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, PoolName).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
    MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
    [ChildSpec :: supervisor:child_spec()]
  }} |
  ignore |
  {error, Reason :: term()}).


init(PoolName) ->
  PoolOpt  = [ {overrun_warning, infinity},
    {overrun_handler, {error_logger, warning_report}}
    , {workers, 50}
    , {worker, {push_worker, push_config()}}
  ],

  Flags = #{ strategy  => one_for_one
    , intensity => 1000
    , period    => 3600
  },

  Children = [#{ id       => wpool
    , start    => {wpool, start_pool, [PoolName, PoolOpt]}
    , restart  => permanent
    , shutdown => 5000
    , type     => supervisor
    , modules  => [wpool]
  }],

  {ok, {Flags, Children}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

push_config() ->
  % this should be in a config file
  #{ name       => undefined,
    apple_host => "api.push.apple.com",
    apple_port => 443,
    certfile   => "cert2.pem",
    keyfile    => "key2-noenc.pem",
    timeout    => 10000,
    type       => cert
  }.