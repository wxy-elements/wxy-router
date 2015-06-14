(function() {
  var router;

  router = document.querySelector('wxy-router');

  suite('<wxy-router>', function() {
    return test('defines key', function() {
      assert.equal(router.key, 'main');
    });
  });

}).call(this);
