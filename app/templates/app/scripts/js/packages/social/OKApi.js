(function() {
  var OKApi;

  OKApi = function($, _, md5) {
    var okSignature, parametrize;
    parametrize = function(obj, join) {
      var arrayOfArrays, sortedParams, symbol;
      if (join == null) {
        join = false;
      }
      arrayOfArrays = _.pairs(obj).sort();
      symbol = join ? '&' : '';
      sortedParams = '';
      _.each(arrayOfArrays, function(value) {
        return sortedParams += ("" + (_.first(value)) + "=" + (_.last(value))) + symbol;
      });
      return sortedParams;
    };
    okSignature = function(postData, sessionSecret, application_key) {
      var data, sortedParams;
      data = _.extend({
        application_key: application_key
      }, postData);
      sortedParams = parametrize(data);
      return md5(sortedParams + sessionSecret);
    };
    return OKApi = (function() {
      function OKApi(appId, appKey) {
        this.appId = appId;
        this.appKey = appKey;
        this.OK_COOKIE = "okas_" + this.appId;
        this.OKSR_COOKIE = "oksr_" + this.appId;
        this.reset();
      }

      OKApi.prototype.reset = function() {
        this.isAuth = false;
        return this.user = null;
      };

      OKApi.prototype._getRoles = function() {};

      OKApi.prototype.getOK = function() {
        var async, authData, data;
        async = $.Deferred();
        authData = $.cookie(this.OK_COOKIE);
        this.isAuth = !!authData;
        if (this.isAuth) {
          data = authData.split(';');
          if (data.length !== 2) {
            data = authData.split('%3B');
          }
          if (data.length === 2) {
            async.resolve({
              secret: data[0],
              token: data[1]
            });
          } else {
            async.reject("not valid authData:" + authData);
          }
        } else {
          async.reject("no ok auth");
        }
        return async.promise();
      };

      OKApi.prototype.makeRequest = function(session, method, postData) {
        var requestedData, sig;
        if (session == null) {
          throw new Error("no session");
        }
        sig = okSignature(postData, session.secret, this.appKey);
        requestedData = _.extend({
          access_token: session.token,
          application_key: this.appKey,
          sig: sig
        }, postData);
        return $.ajax({
          url: "/odnoklassniki/fb.do",
          type: method,
          data: requestedData,
          dataType: 'json'
        });
      };

      OKApi.prototype.login = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getOK().done(function() {
          return async.resolve(true);
        }).fail(function(err) {
          var _this = this;
          window.open("/users/auth/odnoklassniki", "ok_auth");
          window.callAuthSuccess = function() {
            window.callAuthSuccess = null;
            window.callAuthFail = null;
            return async.resolve(true);
          };
          return window.callAuthFail = function() {
            window.callAuthSuccess = null;
            window.callAuthFail = null;
            return async.reject(err);
          };
        });
        return async.promise();
      };

      OKApi.prototype.checkAuth = function() {
        return this.getOK();
      };

      OKApi.prototype.getUser = function() {
        var async,
          _this = this;
        async = $.Deferred();
        if (this.user == null) {
          this.getOK().done(function(session) {
            var requestAsync;
            requestAsync = _this.makeRequest(session, 'GET', {
              method: 'users.getCurrentUser'
            });
            return requestAsync.done(function(data) {
              var birthday;
              if (data.error_code != null) {
                return async.reject(data.error_msg);
              }
              try {
                birthday = new Date(r.birthday);
              } catch (_error) {}
              _this.user = {
                id: data.uid,
                first_name: data.first_name,
                last_name: data.last_name,
                username: data.name,
                gender: data.gender,
                avatar: data.pic_1,
                avatar_url: data.pic_2,
                birthday: birthday,
                soc_type: "ok"
              };
              return async.resolve(_this.user);
            }).fail(function(err) {
              return async.reject(err);
            });
          }).fail(function(err) {
            return async.reject(err);
          });
        } else {
          async.resolve(this.user);
        }
        return async.promise();
      };

      OKApi.prototype.logout = function() {
        var async;
        async = $.Deferred();
        $.removeCookie(this.OK_COOKIE);
        $.removeCookie(this.OKSR_COOKIE);
        this.reset();
        async.resolve();
        return async.promise();
      };

      OKApi.prototype.getAlbums = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getOK().done(function(session) {
          var requestAsync;
          requestAsync = _this.makeRequest(session, 'GET', {
            method: 'photos.getAlbums',
            fields: 'album.aid,photo.pic128x128,photo.pic640x480'
          });
          return requestAsync.done(function(data) {
            data = _.map(data['albums'], function(item) {
              var thumb_src;
              if (item.main_photo != null) {
                thumb_src = item.main_photo.pic640x480 || item.main_photo.pic128x128;
              } else {
                thumb_src = item.pic640x480 || item.pic128x128;
              }
              item.album_id = item.aid;
              item.thumb_src = thumb_src;
              item.title = "";
              return item;
            });
            return async.resolve(data);
          }).fail(function(err) {
            return async.reject(err);
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      OKApi.prototype.getPhotos = function(album_id) {
        var async,
          _this = this;
        async = $.Deferred();
        this.getOK().done(function(session) {
          var requestAsync;
          requestAsync = _this.makeRequest(session, 'GET', {
            method: 'photos.getPhotos',
            aid: album_id
          });
          return requestAsync.done(function(data) {
            data = _.map(data['photos'], function(item) {
              item.picture = item.pic128x128;
              item.source = item.pic640x480;
              return item;
            });
            return async.resolve(data);
          }).fail(function(err) {
            return async.reject(err);
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      return OKApi;

    })();
  };

  if ((typeof define === 'function') && (typeof define.amd === 'object') && define.amd) {
    define(["jquery", "underscore", "md5", "jquery.cookie"], function($, _, md5) {
      return OKApi($, _, md5);
    });
  } else {
    window.OKApi = OKApi($, _, md5);
  }

}).call(this);
