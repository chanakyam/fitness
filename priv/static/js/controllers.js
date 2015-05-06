var app = angular.module('fitness', ['ui.bootstrap']);

app.factory('fitnessHomePageService', function ($http) {
	return {		

		getChannelPictures: function (count, skip) {
			return $http.get('/api/latestnews/channel?&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});
		},
		getChannelBeautyPictures: function (count, skip) {
			return $http.get('/api/latestbeautynews/channel?&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});
		},
		getChannelVideos: function (count, skip) {
      return $http.get('/api/latestvideos/channel?l=' + count + '&skip=' + skip).then(function (result) {
        return result.data.articles;
      });
    }		
	};
});

app.controller('FitnessHome', function ($scope, fitnessHomePageService) {
  //the clean and simple way
  $scope.latestNews = fitnessHomePageService.getChannelPictures(9,0);
  $scope.latestNews1 = fitnessHomePageService.getChannelPictures(3,0);
  $scope.latestNews2 = fitnessHomePageService.getChannelPictures(6,0);	
  $scope.beautyNews = fitnessHomePageService.getChannelBeautyPictures(9,0);
  $scope.beautyNews1 = fitnessHomePageService.getChannelBeautyPictures(7,0);
  $scope.beautyImgs = fitnessHomePageService.getChannelBeautyPictures(6,0);
  $scope.latestVideos = fitnessHomePageService.getChannelVideos(7,0);	
  $scope.latestVideos1 = fitnessHomePageService.getChannelVideos(3,0);
  $scope.currentYear = (new Date).getFullYear();
});




