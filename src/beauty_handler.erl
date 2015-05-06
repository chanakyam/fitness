-module(beauty_handler).
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

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=8&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	BeautyNews1_Url = "http://api.contentapi.ws/news?channel=beauty&limit=1&skip=0&format=short",
	{ok, "200", _, Response_BeautyNews1} = ibrowse:send_req(BeautyNews1_Url,[],get,[],[]),
	ResponseParams_BeautyNews1 = jsx:decode(list_to_binary(Response_BeautyNews1)),	
	[BeautyNewsParams1] = proplists:get_value(<<"articles">>, ResponseParams_BeautyNews1),
	% io:format("data: ~p~n",[BeautyNewsParams1]),

	BeautyNews_Url = "http://api.contentapi.ws/news?channel=beauty&limit=5&skip=0&format=short",
	{ok, "200", _, Response_BeautyNews} = ibrowse:send_req(BeautyNews_Url,[],get,[],[]),
	ResponseParams_BeautyNews = jsx:decode(list_to_binary(Response_BeautyNews)),	
	BeautyNewsParams = proplists:get_value(<<"articles">>, ResponseParams_BeautyNews),
	% io:format("data: ~p~n",[BeautyNewsParams]),


	BeautyNews8_Url = "http://api.contentapi.ws/news?channel=beauty&limit=1&skip=7&format=short",
	{ok, "200", _, Response_BeautyNews8} = ibrowse:send_req(BeautyNews8_Url,[],get,[],[]),
	ResponseParams_BeautyNews8 = jsx:decode(list_to_binary(Response_BeautyNews8)),	
	[BeautyNewsParams8] = proplists:get_value(<<"articles">>, ResponseParams_BeautyNews8),

	% BeautyNews9_Url = "http://api.contentapi.ws/news?channel=beauty&limit=1&skip=8&format=short",
	% {ok, "200", _, Response_BeautyNews9} = ibrowse:send_req(BeautyNews9_Url,[],get,[],[]),
	% ResponseParams_BeautyNews9 = jsx:decode(list_to_binary(Response_BeautyNews9)),	
	% [BeautyNewsParams9] = proplists:get_value(<<"articles">>, ResponseParams_BeautyNews9),

	FitnessImgs_Url = "http://api.contentapi.ws/news?channel=fitness&skip=0&format=short&limit=3",
	{ok, "200", _, Response_FitnessImgs} = ibrowse:send_req(FitnessImgs_Url,[],get,[],[]),
	ResponseParams_FitnessImgs = jsx:decode(list_to_binary(Response_FitnessImgs)),	
	FitnessImgsParams = proplists:get_value(<<"articles">>, ResponseParams_FitnessImgs),

	{ok, Body} = beauty_dtl:render([{<<"videoParam">>,Params},{<<"beautynews">>,BeautyNewsParams},{<<"beautynews1">>,BeautyNewsParams1},{<<"beautynews8">>,BeautyNewsParams8},{<<"fitnessimgs">>,FitnessImgsParams}]),
    {Body, Req, State}
.


