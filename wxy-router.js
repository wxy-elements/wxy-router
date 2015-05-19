(function() {
  var deregisterRouter, extend, registerRouter, routers,
    __slice = [].slice;

  extend = function() {
    var extendee, extendees, key, src, value, _i, _len;
    src = arguments[0], extendees = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    for (_i = 0, _len = extendees.length; _i < _len; _i++) {
      extendee = extendees[_i];
      for (key in extendee) {
        value = extendee[key];
        src[key] = value;
      }
    }
  };

  routers = {};

  registerRouter = function(router) {
    routers[router.key] = router;
  };

  deregisterRouter = function(router) {
    delete routers[router.key];
  };

  Polymer({
    is: "wxy-router",
    properties: {
      key: String
    },
    listeners: {
      'route-attached': 'routeAttached'
    },
    attached: function() {
      registerRouter(this);
      this.router = new RouteRecognizer();
      this.previousRoute = void 0;
      window.addEventListener('popstate', this._OnStateChange.bind(this));
    },
    routeAttached: function(e) {
      this._AddRoute(e.target);
      e.stopPropagation();
    },
    detached: function() {
      deregisterRouter(this);
    },
    go: function(uri, _arg) {
      var data, key, options, router, _ref;
      _ref = _arg != null ? _arg : {}, data = _ref.data, options = _ref.options;
      if (options == null) {
        options = {};
      }
      uri = '#' + uri;
      if (options.replace) {
        window.history.replaceState(null, null, uri);
      } else {
        window.history.pushState(null, null, uri);
      }
      for (key in routers) {
        router = routers[key];
        router._OnStateChange(data);
      }
    },
    _AddRoute: function(route) {
      this.router.add([
        {
          path: route.path,
          handler: route
        }
      ]);
      this._OnStateChange();
    },
    _AddRoutes: function() {
      var route, routes, _i, _len;
      routes = this.children;
      for (_i = 0, _len = routes.length; _i < _len; _i++) {
        route = routes[_i];
        this._AddRoute(route);
      }
    },
    _OnStateChange: function(data) {
      var match, result;
      result = this.router.recognize(window.location.hash.substring(1));
      if (!(result != null ? result.length : void 0) > 0) {
        return;
      }
      match = result[0];
      if (match.handler === this.previousRoute) {
        return;
      }
      match.data = data;
      this._Import(match);
    },
    _Import: function(match) {
      var importUri;
      importUri = match.handler["import"];
      if (importUri) {
        Polymer["import"]([importUri], (function(_this) {
          return function() {
            _this._Activate(match);
          };
        })(this));
      } else {
        this._Activate(match);
      }
    },
    _Activate: function(match) {
      var customElement, elementName, model, route;
      route = match.handler;
      elementName = route.name;
      customElement = document.createElement(elementName);
      model = {
        router: this
      };
      extend(customElement, model, match.params, match.data);
      this._RemoveContent(this.previousRoute);
      this.previousRoute = route;
      route.appendChild(customElement);
    },
    _RemoveContent: function(route) {
      var node, nodeToRemove;
      if (!route) {
        return;
      }
      node = route.firstChild;
      while (nodeToRemove = route.firstChild) {
        route.removeChild(nodeToRemove);
      }
    }
  });

}).call(this);
