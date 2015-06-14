router = document.querySelector 'wxy-router'

suite '<wxy-router>', ->
  test 'defines key', ->
    assert.equal router.key, 'main'
    return
