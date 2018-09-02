%%%-------------------------------------------------------------------
%%% @author Adinarayana
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Sep 2018 12:17 AM
%%%-------------------------------------------------------------------
-module(push_api_handler).
-author("Adinarayana").

%% API
-export([init/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).
-export([allowed_methods/2]).
-export([router/2]).

init(Req, Opts) ->
  {cowboy_rest, Req, Opts}.

allowed_methods(Req, Opts) ->
  {[ <<"POST">>], Req, Opts}.

content_types_provided(Req, Opts) ->
  {[{<<"application/json">>, router}], Req, Opts}.

content_types_accepted(Req, Opts) ->
  {[{<<"application/json">>, router}], Req, Opts}.

router(Req, Opts) ->
  send_push_notif_using_push_pool(cowboy_req:has_body(Req),Req,Opts).


send_push_notif_using_push_pool(true,Req,Opts)->
  DeviceId = cowboy_req:binding(device_id, Req),
  {ok,Body, _} = cowboy_req:body(Req),
  case apple_push_pool:push(DeviceId, Body) of
    {200,_} ->
      Res = cowboy_req:set_resp_body(<<"Successfully sent a Push message\n\n">>, Req),
      {true, Res, Opts};
    _ ->
      Response = cowboy_req:reply(500, Req),
      {true, Response, Opts}
  end;

send_push_notif_using_push_pool(_,Req,Opts) ->
  Req1 = cowboy_req:set_resp_body(<<"Should contain body in request">>, Req),
  Req2 = cowboy_req:reply(400, Req1),
  {true, Req2, Opts}.





