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
    key:
      type: String
      value: ""

  attached: ->
    registerRouter @
    @router = new RouteRecognizer()
    @previousRoute = undefined
    @_AddRoutes()
    @_OnStateChange()
    window.addEventListener 'popstate', @_OnStateChange.bind @
    return

  detached: ->
    deregisterRouter @
    return

  go: (uri, {data, options} = {}) ->
    options ?= {}
    uri = '#' + uri
    if options.replace
      window.history.replaceState null, null, uri
    else
      window.history.pushState null, null, uri

    for key, router of routers
      router._OnStateChange data
    return

  _AddRoutes: ->
    routes = @children
    handlers = {}
    for route in routes
      handler = handlers[route.path] = route

      @router.add [
        path: route.path
        handler: handler
      ]

    return

  _OnStateChange: (data) ->
    result = @router.recognize window.location.hash.substring 1
    return if not result?.length > 0
    match = result[0]
    return if match.handler is @previousRoute
    match.data = data
    @_Import match
    return

  _Import: (match) ->
    importUri = match.handler.import

    if importUri
      Polymer.import [importUri], =>
        @_Activate match
        return
    else
      @_Activate match

    return

  _Activate: (match) ->
    route = match.handler

    elementName = route.name
    customElement = document.createElement elementName
    model =
      router: @

    extend customElement, model, match.params, match.data

    @_RemoveContent @previousRoute
    @previousRoute = route
    route.appendChild customElement
    return

  _RemoveContent: (route) ->
    return if not route

    node = route.firstChild
    while nodeToRemove = route.firstChild
      route.removeChild nodeToRemove

    return
