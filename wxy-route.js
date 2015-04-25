(function() {
  Polymer({
    is: "wxy-route",
    hostAttributes: {
      "class": "fit"
    },
    properties: {
      path: String,
      "import": String,
      name: String
    },
    attached: function() {
      this.fire('route-attached');
    }
  });

}).call(this);
