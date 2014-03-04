(function() {
  var FBApi;

  FBApi = function($, _) {
    return FBApi = (function() {
      function FBApi(appId) {
        this.appId = appId;
        this.reset();
        this.appId = appId;
        this.timeout = null;
        this.TIMEOUT_WAIT = 10000;
      }

      FBApi.prototype.reset = function() {
        this.isAuth = false;
        return this.user = null;
      };

      FBApi.prototype._getRoles = function(FB) {
        return "user_photos";
      };

      FBApi.prototype._startWaitResponse = function(callback) {
        var _this = this;
        this._stopWaitResponse();
        return this.timeout = setTimeout((function() {
          callback();
          return _this.timeout = null;
        }), this.TIMEOUT_WAIT);
      };

      FBApi.prototype._stopWaitResponse = function() {
        if (this.timeout != null) {
          return clearTimeout(this.timeout);
        }
      };

      FBApi.prototype._getStatus = function(async, FB) {
        var _this = this;
        this._startWaitResponse(function() {
          return async.reject("not FB connect", FB);
        });
        return FB.getLoginStatus(function(r) {
          _this._stopWaitResponse();
          if (r.status === "connected") {
            _this.isAuth = true;
            return async.resolve(FB);
          } else {
            _this.reset();
            return async.reject("not auth FB", FB);
          }
        });
      };

      FBApi.prototype.checkAuth = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getFB().always(function(data) {
          if (_this.isAuth) {
            return async.resolve(_this.isAuth);
          } else {
            return async.reject(data);
          }
        });
        return async.promise();
      };

      FBApi.prototype.login = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getFB().always(function(authFB, notAuthFB) {
          var FB;
          if ((FB = notAuthFB)) {
            return FB.login((function(r) {
              if (r.status === "connected") {
                _this.isAuth = true;
                return async.resolve(FB);
              } else {
                _this.reset();
                return async.reject("not auth FB");
              }
            }), {
              scope: _this._getRoles(FB)
            });
          } else {
            return async.resolve(FB);
          }
        });
        return async.promise();
      };

      FBApi.prototype.logout = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getFB().done(function(FB) {
          return FB.logout(function(r) {
            if (r) {
              async.resolve(FB);
              return _this.isAuth = false;
            } else {
              _this.reset();
              return async.reject(FB);
            }
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      FBApi.prototype.getFB = function() {
        var async,
          _this = this;
        async = $.Deferred();
        if (this._$_FB == null) {
          setTimeout((function() {
            var el;
            el = document.createElement("script");
            el.type = "text/javascript";
            el.src = "//connect.facebook.net/ru_RU/all.js";
            el.async = true;
            return document.getElementsByTagName("body")[0].appendChild(el);
          }), 0);
          window.fbAsyncInit = function() {
            var FB;
            window.fbAsyncInit = null;
            _this._$_FB = FB = window.FB;
            FB.init({
              appId: _this.appId,
              status: true,
              cookie: true,
              xfbml: true,
              oauth: true
            });
            return _this._getStatus(async, FB);
          };
        } else if (this.isAuth) {
          async.resolve(this._$_FB);
        } else {
          this._getStatus(async, this._$_FB);
        }
        return async.promise();
      };

      FBApi.prototype.getUser = function() {
        var async,
          _this = this;
        async = $.Deferred();
        if (this.user != null) {
          async.resolve(this.user, FB);
        } else {
          this.getFB().done(function(FB) {
            return FB.api('/me?locale=en_EN', function(r) {
              var birthday, rpl, rx;
              if (!!r.error) {
                return async.reject(r.error);
              } else {
                try {
                  rx = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
                  rpl = '$3-$1-$2';
                  birthday = new Date(r.birthday.replace(rx, rpl));
                } catch (_error) {}
                _this.user = {
                  id: r.id,
                  first_name: r.first_name,
                  last_name: r.last_name,
                  username: r.username,
                  avatar_url: "https://graph.facebook.com/" + r.id + "/picture?width=150&height=150",
                  avatar: "https://graph.facebook.com/" + r.id + "/picture?type=square",
                  gender: r.gender,
                  birthday: birthday,
                  soc_type: "fb"
                };
                return async.resolve(_this.user, FB);
              }
            });
          }).fail(function(err) {
            return async.reject(err);
          });
        }
        return async.promise();
      };

      FBApi.prototype.getAlbums = function() {
        var async;
        async = $.Deferred();
        this.getFB().done(function(FB) {
          return FB.api({
            method: "fql.multiquery",
            queries: {
              query1: "select object_id, owner, created, modified, aid,name,link,photo_count,cover_object_id from album where owner = me()",
              query2: "SELECT pid,src,src_big FROM photo WHERE object_id  IN (SELECT cover_object_id FROM #query1)"
            }
          }, function(response) {
            var parsed;
            parsed = new Array();
            _.each(response[0].fql_result_set, function(value, index) {
              var thumb_src;
              thumb_src = response[1].fql_result_set[index].src_big || response[1].fql_result_set[index].src;
              return parsed.push({
                id: value.object_id,
                title: value.name,
                owner_id: value.owner,
                size: parseInt(value.photo_count),
                thumb_id: response[0].fql_result_set[index].cover_object_id,
                thumb_src: thumb_src,
                created: new Date(value.created),
                updated: new Date(value.modified),
                aid: value.object_id,
                album_id: value.object_id,
                link: value.link
              });
            });
            return async.resolve(parsed);
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      FBApi.prototype.getPhotos = function(album_id) {
        var async;
        async = $.Deferred();
        this.getFB().done(function(FB) {
          return FB.api("" + album_id + "/photos", function(r) {
            return async.resolve(r.data);
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      return FBApi;

    })();
  };

  if ((typeof define === 'function') && (typeof define.amd === 'object') && define.amd) {
    define(["jquery", "underscore"], function($, _) {
      return FBApi($, _);
    });
  } else {
    window.FBApi = FBApi($, _);
  }

}).call(this);
