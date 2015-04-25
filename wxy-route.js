(function() {
  Polymer({
    is: "wxy-route",
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
