(function() {
  var SocialApi;

  SocialApi = function($) {
    return SocialApi = (function() {
      function SocialApi(social) {
        this.social = social;
      }

      SocialApi.prototype._getCurrentSocial = function() {
        var currentName, finishCheckStatus, names,
          _this = this;
        if (this.currentSocial == null) {
          this.currentSocial = $.Deferred();
          names = _.keys(this.social);
          currentName = null;
          finishCheckStatus = _.after(names.length, function() {
            if (currentName == null) {
              return _this.currentSocial.reject("not auth");
            }
          });
          _.each(names, function(name) {
            return _this.checkAuth(name).done(function(name) {
              if (currentName == null) {
                currentName = name;
                return _this.currentSocial.resolve(name);
              } else {
                return _this.social[name].logout();
              }
            }).always(function() {
              return finishCheckStatus(name);
            });
          });
        }
        return this.currentSocial.promise();
      };

      SocialApi.prototype.checkAuth = function(name) {
        var api, async;
        async = $.Deferred();
        if ((api = this.social[name])) {
          api.checkAuth().done(function() {
            return async.resolve(name);
          }).fail(function() {
            return async.reject(false);
          });
        } else {
          async.reject("no provider " + name);
        }
        return async.promise();
      };

      SocialApi.prototype._get = function(callback) {
        var async,
          _this = this;
        async = $.Deferred();
        this._getCurrentSocial().done(function(name) {
          if (_this.social[name] != null) {
            return callback(async, _this.social[name], name);
          } else {
            return async.reject("no provider " + name);
          }
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      SocialApi.prototype.isAuth = function() {
        return this._get(function(async, self) {
          return async.resolve(self.isAuth);
        });
      };

      SocialApi.prototype.login = function(name) {
        var async, self,
          _this = this;
        async = $.Deferred();
        if ((self = this.social[name])) {
          self.login().done(function(data) {
            _this.currentSocial = $.Deferred();
            _this.currentSocial.resolve(name);
            return async.resolve(data);
          }).fail(function(err) {
            return async.reject(err);
          });
        } else {
          self.reject("no provider " + name);
        }
        return async.promise();
      };

      SocialApi.prototype.logout = function() {
        var _this = this;
        return this._get(function(async, self) {
          return self.logout().done(function(data) {
            _this.currentSocial = $.Deferred();
            _this.currentSocial.reject("not auth");
            return async.resolve(data);
          }).fail(function(err) {
            return async.reject(err);
          });
        });
      };

      SocialApi.prototype.getUser = function() {
        var _this = this;
        return this._get(function(async, self, name) {
          return self.getUser().done(function(data) {
            data.soc_type = name;
            return async.resolve(data);
          }).fail(function(err) {
            return _this.logout().always(function() {
              return async.reject(err);
            });
          });
        });
      };

      SocialApi.prototype.getAlbums = function() {
        return this._get(function(async, self) {
          return self.getAlbums().done(function(data) {
            return async.resolve(data);
          }).fail(function(err) {
            return async.reject(err);
          });
        });
      };

      SocialApi.prototype.getPhotos = function(album_id) {
        return this._get(function(async, self) {
          return self.getPhotos(album_id).done(function(data) {
            return async.resolve(data);
          }).fail(function(err) {
            return async.reject(err);
          });
        });
      };

      return SocialApi;

    })();
  };

  if ((typeof define === 'function') && (typeof define.amd === 'object') && define.amd) {
    define(["jquery"], function($) {
      return SocialApi($);
    });
  } else {
    window.SocialApi = SocialApi($);
  }

}).call(this);
