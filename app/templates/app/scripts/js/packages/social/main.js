(function() {
  define(function(require, exports, module) {
    return {
      FBApi: require('./FBApi'),
      OKApi: require('./OKApi'),
      VKApi: require('./VKApi'),
      SocialApi: require('./SocialApi')
    };
  });

}).call(this);
