extend = (src, extendees...) ->
  for extendee in extendees
    for key, value of extendee
      src[key] = value

  return

routers = {}
registerRouter = (router) ->
  routers[router.key] = router
  return

deregisterRouter = (router) ->
  delete routers[router.key]
  return

Polymer
  is: "wxy-router"

  properties:
    key: String
    hash:
      type: String
      notify: true

  listeners:
    'route-attached': '_routeAttached'

  attached: ->
    registerRouter @
    @router = new RouteRecognizer()
    @previousRoute = undefined
    window.addEventListener 'popstate', @_onStateChange.bind @
    return

  detached: ->
    deregisterRouter @
    return

  go: (uri, {data, options} = {}) ->
    hash = window.location.hash.substring 1
    return if hash is uri
    options ?= {}
    uri = '#' + uri
    if options.replace
      window.history.replaceState null, null, uri
    else
      window.history.pushState null, null, uri

    for key, router of routers
      router._onStateChange data
    return

  _addRoute: (route) ->
    @router.add [
      path: route.path
      handler: route
    ]

    @_onStateChange()
    return

  _addRoutes: ->
    routes = @children
    @_addRoute route for route in routes
    return

  _onStateChange: (data) ->
    @hash = window.location.hash.substring 1
    result = @router.recognize @hash
    return if not result?.length > 0
    match = result[0]
    return if match.handler is @previousRoute
    match.data = data
    @_import match
    return

  _import: (match) ->
    importUri = match.handler.import

    if importUri
      @importHref importUri, =>
        @_activate match
        return
    else
      @_activate match

    return

  _activate: (match) ->
    route = match.handler

    elementName = route.name
    customElement = document.createElement elementName
    model =
      router: @

    extend customElement, model, match.params, match.data

    @_removeContent @previousRoute
    @previousRoute = route
    route.appendChild customElement
    return

  _removeContent: (route) ->
    return if not route

    node = route.firstChild
    while nodeToRemove = route.firstChild
      route.removeChild nodeToRemove

    return

  _routeAttached: (e) ->
    @_addRoute e.target
    e.stopPropagation()
    return
