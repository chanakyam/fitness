-module(home_page_handler).
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
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=5&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),
	% io:format("params: ~p~n",[Params]),
	% LatestNews1_Url = "http://api.contentapi.ws/news?channel=fitness&limit=1&skip=0&format=short",
	LatestNews1_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_health_news_online/_view/short?descending=true&limit=1&skip=0",
	
	{ok, "200", _, Response_LatestNews1} = ibrowse:send_req(LatestNews1_Url,[],get,[],[]),
	ResponseParams_LatestNews1 = jsx:decode(list_to_binary(Response_LatestNews1)),	
	[LatestNewsParams1] = proplists:get_value(<<"rows">>, ResponseParams_LatestNews1),
	% io:format("data: ~p~n",[LatestNewsParams1]),

	% LatestNews_Url = "http://api.contentapi.ws/news?channel=fitness&limit=5&skip=0&format=short",
	LatestNews_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_health_news_online/_view/short?descending=true&limit=5&skip=0",
	
	{ok, "200", _, Response_LatestNews} = ibrowse:send_req(LatestNews_Url,[],get,[],[]),
	ResponseParams_LatestNews = jsx:decode(list_to_binary(Response_LatestNews)),	
	LatestNewsParams = proplists:get_value(<<"rows">>, ResponseParams_LatestNews),	
	

	% LatestNews8_Url = "http://api.contentapi.ws/news?channel=fitness&limit=1&skip=7&format=short",
	LatestNews8_Url = "http://contentapi.ws:5984/contentapi_text_maxcdn/_design/yb_health_news_online/_view/short?descending=true&limit=1&skip=7",
	{ok, "200", _, Response_LatestNews8} = ibrowse:send_req(LatestNews8_Url,[],get,[],[]),
	ResponseParams_LatestNews8 = jsx:decode(list_to_binary(Response_LatestNews8)),	
	LatestNewsParams8 = proplists:get_value(<<"rows">>, ResponseParams_LatestNews8),

	% LatestNews9_Url = "http://api.contentapi.ws/news?channel=fitness&limit=1&skip=8&format=short",
	% {ok, "200", _, Response_LatestNews9} = ibrowse:send_req(LatestNews9_Url,[],get,[],[]),
	% ResponseParams_LatestNews9 = jsx:decode(list_to_binary(Response_LatestNews9)),	
	% [LatestNewsParams9] = proplists:get_value(<<"articles">>, ResponseParams_LatestNews9),

	% BeautyImgs_Url = "http://api.contentapi.ws/news?channel=beauty&skip=0&format=short&limit=6",
	% {ok, "200", _, Response_BeautyImgs} = ibrowse:send_req(BeautyImgs_Url,[],get,[],[]),
	% ResponseParams_BeautyImgs = jsx:decode(list_to_binary(Response_BeautyImgs)),	
	% BeautyImgsParams = proplists:get_value(<<"articles">>, ResponseParams_BeautyImgs),
	
	{ok, Body} = index_dtl:render([{<<"videoParam">>,Params},{<<"latestnews1">>,LatestNewsParams1},{<<"latestnews">>,LatestNewsParams},{<<"latestnews8">>,LatestNewsParams8}]),
    {Body, Req, State}
.
    
