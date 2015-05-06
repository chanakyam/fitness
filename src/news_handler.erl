-module(news_handler).
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

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=6&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Url_news = string:concat("http://api.contentapi.ws/t?id=",binary_to_list(Value) ),
	Url_news = string:concat("http://contentapi.ws:5984/contentapi_text_maxcdn/",binary_to_list(Value) ),
	{ok, "200", _, ResponseNews} = ibrowse:send_req(Url_news,[],get,[],[]),
	ResNews = string:sub_string(ResponseNews, 1, string:len(ResponseNews) -1 ),
	ParamsNews = jsx:decode(list_to_binary(ResNews)),

	% FitnessHot_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=1",
	FitnessHot_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_health_news_online/_view/short?descending=true&limit=1&skip=0",
	{ok, "200", _, Response_FitnessHot} = ibrowse:send_req(FitnessHot_Url,[],get,[],[]),
	ResponseParams_FitnessHot = jsx:decode(list_to_binary(Response_FitnessHot)),	
	[FitnessHotParams] = proplists:get_value(<<"rows">>, ResponseParams_FitnessHot),

	Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&skip=0&format=short&limit=10",
	{ok, "200", _, Response_Videos} = ibrowse:send_req(Videos_Url,[],get,[],[]),
	ResponseParams_Videos = jsx:decode(list_to_binary(Response_Videos)),	
	VideosParams = proplists:get_value(<<"articles">>, ResponseParams_Videos),

	% Beauty1_Url = "http://api.contentapi.ws/news?channel=beauty&skip=0&format=short&limit=1",
	% {ok, "200", _, Response_Beauty1} = ibrowse:send_req(Beauty1_Url,[],get,[],[]),
	% ResponseParams_Beauty1 = jsx:decode(list_to_binary(Response_Beauty1)),	
	% [Beauty1Params] = proplists:get_value(<<"articles">>, ResponseParams_Beauty1),

	% Beauty_Url = "http://api.contentapi.ws/news?channel=beauty&skip=1&format=short&limit=6",
	% {ok, "200", _, Response_Beauty} = ibrowse:send_req(Beauty_Url,[],get,[],[]),
	% ResponseParams_Beauty = jsx:decode(list_to_binary(Response_Beauty)),	
	% BeautyParams = proplists:get_value(<<"articles">>, ResponseParams_Beauty),

	{ok, Body} = news_dtl:render([{<<"videoParam">>,Params},{<<"newsParam">>,ParamsNews},{<<"fitnesshot">>,FitnessHotParams},{<<"videos">>,VideosParams}]),
    {Body, Req2, State}.



