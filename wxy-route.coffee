Polymer
  is: "wxy-route"

  hostAttributes:
    class: "fit"

  properties:
    path: String
    import: String
    name: String

  attached: ->
    @fire 'route-attached'
    return
