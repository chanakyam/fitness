-module(beautynews_handler).
-author("chanakyam@koderoom.com").

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
	{[{_,Value}], Req2} = cowboy_req:bindings(Req),	

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=7&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	Url_news = string:concat("http://api.contentapi.ws/t?id=",binary_to_list(Value) ),
	%io:format("url: ~p~n",[Url]),	
	{ok, "200", _, ResponseNews} = ibrowse:send_req(Url_news,[],get,[],[]),
	ResNews = string:sub_string(ResponseNews, 1, string:len(ResponseNews) -1 ),
	ParamsNews = jsx:decode(list_to_binary(ResNews)),

	FitnessHot_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=1",
	{ok, "200", _, Response_FitnessHot} = ibrowse:send_req(FitnessHot_Url,[],get,[],[]),
	ResponseParams_FitnessHot = jsx:decode(list_to_binary(Response_FitnessHot)),	
	[FitnessHotParams] = proplists:get_value(<<"articles">>, ResponseParams_FitnessHot),

	Fitness_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=6",
	{ok, "200", _, Response_Fitness} = ibrowse:send_req(Fitness_Url,[],get,[],[]),
	ResponseParams_Fitness = jsx:decode(list_to_binary(Response_Fitness)),	
	FitnessParams = proplists:get_value(<<"articles">>, ResponseParams_Fitness),

	Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&skip=0&format=short&limit=3",
	{ok, "200", _, Response_Videos} = ibrowse:send_req(Videos_Url,[],get,[],[]),
	ResponseParams_Videos = jsx:decode(list_to_binary(Response_Videos)),	
	VideosParams = proplists:get_value(<<"articles">>, ResponseParams_Videos),

	{ok, Body} = beautynews_dtl:render([{<<"videoParam">>,Params}, {<<"newsParam">>,ParamsNews},{<<"fitnesshot">>,FitnessHotParams},{<<"fitness">>,FitnessParams},{<<"videos">>,VideosParams}]),
    {Body, Req2, State}.


