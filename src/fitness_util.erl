-module(fitness_util).
-include("includes.hrl").

-export([newsdb_url/0,	
		 videosdb_url/0,	 		  
		 thumb_title_count/3,
		 get_beauty_data/3,
		 news_item_url/1,
		 news_top_text_news_by_category_with_limit_and_skip/3,
		 beautynews_top_text_news_by_category_with_limit_and_skip/3,
		 videos_top_text_news_by_category_with_limit_and_skip/3,
		 news_count/1,
		 video_count/3,
		 beautynews_count/1,
		 videos_count/1,
		 play_video_item_url/1		 
		]).

newsdb_url() ->
	string:concat(?COUCHDB_URL, ?COUCHDB_TEXT_GRAPHICS)
.
videosdb_url() ->
	string:concat(?COUCHDB_URL, ?COUCHDB_TEXT_GRAPHICS_VIDEOS)
.
video_count(Category, Limit, Skip) ->
	Url1 = string:concat(?MODULE:videosdb_url(),"_design/video_movies/_view/"),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.

thumb_title_count(Category, Limit, Skip) ->
	Url1 = string:concat(?MODULE:newsdb_url(),"_design/fitness_design/_view/"),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.
get_beauty_data(Category, Limit, Skip) ->
	Url1 = string:concat(?MODULE:newsdb_url(),"_design/beauty_design/_view/"),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.
news_item_url(Id) ->
	string:concat(?MODULE:newsdb_url(),Id)
.
news_top_text_news_by_category_with_limit_and_skip(Category, Limit, Skip) ->
	Url  = string:concat(?MODULE:newsdb_url(), "_design/fitness_design/_view/"), 
	Url1 = string:concat(Url,Category ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)	
.
beautynews_top_text_news_by_category_with_limit_and_skip(Category, Limit, Skip) ->
	Url  = string:concat(?MODULE:newsdb_url(), "_design/beauty_design/_view/"), 
	Url1 = string:concat(Url,Category ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)	
.
videos_top_text_news_by_category_with_limit_and_skip(Category, Limit, Skip) ->
	Url  = string:concat(?MODULE:videosdb_url(), "_design/video_movies/_view/"), 
	Url1 = string:concat(Url,Category ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)	
.
news_count(Category) ->
	Url1 = string:concat(?MODULE:newsdb_url(), "_design/fitness_design/_view/"),
	Url2 = string:concat(Url1, Category),	
	string:concat(Url2, "?descending=true&limit=1")
.
beautynews_count(Category) ->
	Url1 = string:concat(?MODULE:newsdb_url(), "_design/beauty_design/_view/"),
	Url2 = string:concat(Url1, Category),	
	string:concat(Url2, "?descending=true&limit=1")
.
videos_count(Category) ->
	Url1 = string:concat(?MODULE:videosdb_url(), "_design/video_movies/_view/"),
	Url2 = string:concat(Url1, Category),	
	string:concat(Url2, "?descending=true&limit=1")
.
play_video_item_url(Id) ->
	string:concat(?MODULE:videosdb_url(),Id)
.

