-module(all_videos_handler).
-author("chanakyam@koderoom.com").
-include("includes.hrl").
-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->	
	% {PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	% PageNum = list_to_integer(binary_to_list(PageBinary)),
	% SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,
	% {CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	% Category = binary_to_list(CategoryBinary),

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=9&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Url_all_news = string:concat("http://api.contentapi.ws/videos?channel=world_news&format=short&limit=20&skip=",integer_to_list(SkipItems)),
	Url_all_news = "http://api.contentapi.ws/videos?channel=world_news&format=short&limit=30&skip=0",
	{ok, "200", _, Response} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(Response)),	
	ParamsAllNews = proplists:get_value(<<"articles">>, ResponseParams),

	% FitnessHot_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=1",
	FitnessHot_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_health_news_online/_view/short?descending=true&limit=1&skip=0",
	{ok, "200", _, Response_FitnessHot} = ibrowse:send_req(FitnessHot_Url,[],get,[],[]),
	ResponseParams_FitnessHot = jsx:decode(list_to_binary(Response_FitnessHot)),	
	[FitnessHotParams] = proplists:get_value(<<"rows">>, ResponseParams_FitnessHot),

	% Fitness_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=6",
	Fitness_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_health_news_online/_view/short?descending=true&limit=15&skip=0",
	{ok, "200", _, Response_Fitness} = ibrowse:send_req(Fitness_Url,[],get,[],[]),
	ResponseParams_Fitness = jsx:decode(list_to_binary(Response_Fitness)),	
	FitnessParams = proplists:get_value(<<"rows">>, ResponseParams_Fitness),

	% Beauty1_Url = "http://api.contentapi.ws/news?channel=beauty&skip=0&format=short&limit=1",
	% {ok, "200", _, Response_Beauty1} = ibrowse:send_req(Beauty1_Url,[],get,[],[]),
	% ResponseParams_Beauty1 = jsx:decode(list_to_binary(Response_Beauty1)),	
	% [Beauty1Params] = proplists:get_value(<<"articles">>, ResponseParams_Beauty1),

	% Beauty_Url = "http://api.contentapi.ws/news?channel=beauty&skip=1&format=short&limit=6",
	% {ok, "200", _, Response_Beauty} = ibrowse:send_req(Beauty_Url,[],get,[],[]),
	% ResponseParams_Beauty = jsx:decode(list_to_binary(Response_Beauty)),	
	% BeautyParams = proplists:get_value(<<"articles">>, ResponseParams_Beauty),

	{ok, Body} = all_videos_paginated_dtl:render([{<<"videoParam">>,Params},{<<"allnews">>,ParamsAllNews},{<<"fitnesshot">>,FitnessHotParams},{<<"fitness">>,FitnessParams}]),
    {Body, Req, State}.


