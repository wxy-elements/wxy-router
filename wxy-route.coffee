Polymer
  is: "wxy-route"

  properties:
    path: String
    import: String
    name: String

  attached: ->
    @fire 'route-attached'
    return
