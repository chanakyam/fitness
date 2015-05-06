-module(all_beautynews_handler).
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
	{PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	PageNum = list_to_integer(binary_to_list(PageBinary)),
	SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,
	{CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	Category = binary_to_list(CategoryBinary),

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=12&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),	

	Url_all_news = string:concat("http://api.contentapi.ws/news?channel=beauty&limit=15&format=short&skip=", integer_to_list(SkipItems)),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(ResponseAllNews)),
	ResAllNews = proplists:get_value(<<"articles">>, ResponseParams),

	FitnessHot_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=1",
	{ok, "200", _, Response_FitnessHot} = ibrowse:send_req(FitnessHot_Url,[],get,[],[]),
	ResponseParams_FitnessHot = jsx:decode(list_to_binary(Response_FitnessHot)),	
	[FitnessHotParams] = proplists:get_value(<<"articles">>, ResponseParams_FitnessHot),

	Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&skip=0&format=short&limit=6",
	{ok, "200", _, Response_Videos} = ibrowse:send_req(Videos_Url,[],get,[],[]),
	ResponseParams_Videos = jsx:decode(list_to_binary(Response_Videos)),	
	VideosParams = proplists:get_value(<<"articles">>, ResponseParams_Videos),

	Fitness1_Url = "http://api.contentapi.ws/news?channel=beauty&skip=0&format=short&limit=1",
	{ok, "200", _, Response_Fitness1} = ibrowse:send_req(Fitness1_Url,[],get,[],[]),
	ResponseParams_Fitness1 = jsx:decode(list_to_binary(Response_Fitness1)),	
	[Fitness1Params] = proplists:get_value(<<"articles">>, ResponseParams_Fitness1),

	Fitness_Url = "http://api.contentapi.ws/news?channel=beauty&skip=1&format=short&limit=6",
	{ok, "200", _, Response_Fitness} = ibrowse:send_req(Fitness_Url,[],get,[],[]),
	ResponseParams_Fitness = jsx:decode(list_to_binary(Response_Fitness)),	
	FitnessParams = proplists:get_value(<<"articles">>, ResponseParams_Fitness),

	{ok, Body} = all_beautynews_paginated_dtl:render([{<<"videoParam">>,Params},{<<"news_category">>,Category},{<<"allnews">>,ResAllNews},{<<"fitnesshot">>,FitnessHotParams},{<<"videos">>,VideosParams},{<<"fitness1">>,Fitness1Params},{<<"fitness">>,FitnessParams}]),
    {Body, Req, State}.


