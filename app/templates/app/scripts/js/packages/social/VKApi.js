(function() {
  var VKApi;

  VKApi = function($) {
    return VKApi = (function() {
      function VKApi(appID) {
        this.appID = appID;
        this.version = "5.11";
        this.reset();
        this.timeout = null;
        this.TIMEOUT_WAIT = 10000;
      }

      VKApi.prototype.reset = function() {
        this.user = null;
        return this.isAuth = false;
      };

      VKApi.prototype._startWaitResponse = function(callback) {
        var _this = this;
        this._stopWaitResponse();
        return this.timeout = setTimeout((function() {
          callback();
          return _this.timeout = null;
        }), this.TIMEOUT_WAIT);
      };

      VKApi.prototype._stopWaitResponse = function() {
        if (this.timeout != null) {
          return clearTimeout(this.timeout);
        }
      };

      VKApi.prototype.getVK = function() {
        var async,
          _this = this;
        async = $.Deferred();
        if (this._$_VK == null) {
          setTimeout((function() {
            var el;
            el = document.createElement("script");
            el.type = "text/javascript";
            el.src = "//vk.com/js/api/openapi.js";
            el.async = true;
            return document.getElementsByTagName("body")[0].appendChild(el);
          }), 0);
          window.vkAsyncInit = function() {
            var VK;
            window.vkAsyncInit = null;
            _this._$_VK = VK = window.VK;
            VK.init({
              apiId: _this.appID
            });
            return _this._getStatus(async, VK);
          };
        } else if (this.isAuth) {
          async.resolve(this._$_VK);
        } else {
          this._getStatus(async, VK);
        }
        return async.promise();
      };

      VKApi.prototype.checkAuth = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getVK().always(function(data) {
          if (_this.isAuth) {
            return async.resolve(_this.isAuth);
          } else {
            return async.reject(data);
          }
        });
        return async.promise();
      };

      VKApi.prototype._getRoles = function(VK) {
        return VK.access.PHOTOS;
      };

      VKApi.prototype._getStatus = function(async, VK) {
        var _this = this;
        this._startWaitResponse(function() {
          return async.reject("not VK connect", VK);
        });
        return VK.Auth.getLoginStatus(function(resp) {
          if (resp.session) {
            _this.isAuth = true;
            return async.resolve(VK);
          } else {
            _this.reset();
            return async.reject("no auth VK", VK);
          }
        });
      };

      VKApi.prototype.login = function() {
        var async,
          _this = this;
        async = $.Deferred();
        this.getVK().always(function(authVK, notAuthVK) {
          var VK;
          if ((VK = notAuthVK) || (VK = authVK)) {
            return VK.Auth.login((function(resp) {
              if (resp.session) {
                _this.isAuth = true;
                return async.resolve(VK);
              } else {
                _this.reset();
                return async.reject("no auth VK", VK);
              }
            }), _this._getRoles(VK));
          }
        });
        return async.promise();
      };

      VKApi.prototype.logout = function(callback) {
        var async,
          _this = this;
        async = $.Deferred();
        this.getVK().done(function(VK) {
          return VK.Auth.logout(function(r) {
            if (!!r.error) {
              return async.reject(r.error);
            } else {
              _this.reset();
              return async.resolve(r.response);
            }
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      VKApi.prototype.getUser = function() {
        var async,
          _this = this;
        async = $.Deferred();
        if (this.user != null) {
          async.resolve(this.user, VK);
        } else {
          this.getVK().done(function(VK) {
            return VK.Api.call('users.get', {
              v: _this.version,
              fields: "photo_200_orig,photo_50,sex,bdate"
            }, function(r) {
              var birthday, gender, rpl, rx, user;
              if (!!r.error) {
                async.reject(r.error);
              } else {
                user = r != null ? r.response[0] : void 0;
                gender = user.sex === 1 ? "female" : user.sex === 2 ? "male" : void 0;
                try {
                  rx = /(\d{1,2})\.(\d{1,2})\.(\d{4})/;
                  rpl = '$3-$2-$1';
                  birthday = new Date(user.bdate.replace(rx, rpl));
                } catch (_error) {}
                _this.user = {
                  id: user.id,
                  first_name: user.first_name,
                  last_name: user.last_name,
                  username: "" + user.first_name + " " + user.last_name,
                  avatar_url: user['photo_200_orig'],
                  avatar: user['photo_50'],
                  gender: gender,
                  birthday: birthday,
                  soc_type: "vk"
                };
              }
              return async.resolve(_this.user, VK);
            });
          }).fail(function(err, VK) {
            return async.reject(err);
          });
        }
        return async.promise();
      };

      VKApi.prototype.getAlbums = function() {
        var async;
        async = $.Deferred();
        this.getUser().done(function(user, VK) {
          return VK.Api.call("photos.getAlbums", {
            owner_id: user.id,
            need_covers: 1,
            album_ids: true,
            photo_sizes: 1,
            v: this.version
          }, function(r) {
            var data;
            if (!!r.error) {
              return async.reject(r.error);
            } else {
              data = _.map(r.response, function(item) {
                item.album_id = item.aid;
                return item.thumb_src = (_.where(item.sizes, {
                  type: "x"
                }))[0].src;
              });
              return async.resolve(r.response);
            }
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      VKApi.prototype.getPhotos = function(album_id) {
        var async;
        async = $.Deferred();
        this.getUser().done(function(user, VK) {
          return VK.Api.call("photos.get", {
            owner_id: user.id,
            album_id: album_id,
            photo_sizes: 1,
            v: this.version
          }, function(r) {
            var data;
            if (!!r.error) {
              return async.reject(r.error);
            } else {
              data = _.map(r.response, function(item) {
                item.picture = (_.where(item.sizes, {
                  type: "x"
                }))[0].src;
                return item.source = item.sizes[2].src;
              });
              return async.resolve(r.response);
            }
          });
        }).fail(function(err) {
          return async.reject(err);
        });
        return async.promise();
      };

      return VKApi;

    })();
  };

  if ((typeof define === 'function') && (typeof define.amd === 'object') && define.amd) {
    define(["jquery"], function($) {
      return VKApi($);
    });
  } else {
    window.VKApi = VKApi($);
  }

}).call(this);
