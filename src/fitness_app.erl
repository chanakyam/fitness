-module(fitness_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_',[
                {"/", home_page_handler, []},
                {"/api/latestnews/channel", channel_latestnews_handler, []},
                {"/api/latestbeautynews/channel", channel_latestbeautynews_handler, []},
                {"/api/latestvideos/channel", channel_latestvideos_handler, []},
                {"/news/:id", news_handler, []},
                {"/beautynews/:id", beautynews_handler, []},
                {"/morenews", all_news_handler, []},
                {"/morebeautynews", all_beautynews_handler, []},
                {"/beauty", beauty_handler, []},
                {"/videos", all_videos_handler, []},
                {"/api/news/count", news_count_handler, []},
                {"/api/beautynews/count", beautynews_count_handler, []},
                {"/api/videos/count", videos_count_handler, []},
                {"/playvideo/:id", play_video_handler, []},                
                %%
                %% Release Routes
                %%
    			{"/css/[...]", cowboy_static, {priv_dir, fitness, "static/css"}},
    			{"/images/[...]", cowboy_static, {priv_dir, fitness, "static/images"}},
    			{"/js/[...]", cowboy_static, {priv_dir, fitness, "static/js"}},
				{"/fonts/[...]", cowboy_static, {priv_dir, fitness, "static/fonts"}}
				%%
				%% Dev Routes
				%%
				% {"/css/[...]", cowboy_static, {dir, "priv/static/css"}},
    %             {"/images/[...]", cowboy_static, {dir, "priv/static/images"}},
    %             {"/js/[...]", cowboy_static, {dir,"priv/static/js"}},
				% {"/fonts/[...]", cowboy_static, {dir, "priv/static/fonts"}}
        ]}		
	]), 
    

	{ok, _} = cowboy:start_http(http,100, [{port, 9916}],[{env, [{dispatch, Dispatch}]}
              ]),
    fitness_sup:start_link().

stop(_State) ->
    ok.
