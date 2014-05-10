root = exports ? this

usTpl = """
<div class="content">
  <h1 data-test="example">Test Content</h1>
  <p><%= paraMessage %></p>
  <ul>
    <li><%= li1 %></li>
    <li><%= li2 %></li>
  </ul>
</div>
"""

frTpl = """
.content
  h1{"data-test": "example"} Test Content
  p = @paraMessage
  ul
    li = @li1
    li = @li2
"""


root.init = ->
  counter = document.getElementById('count')
  run = document.getElementById('run')
  clear = document.getElementById('clear')

  run.addEventListener 'click', ->
    performanceTest(parseInt(counter.value))

  clear.addEventListener 'click', ->
    document.getElementById('fixture').innerHTML = ""


root.performanceTest = (iterations) ->
  console.time('underscore')
  for i in [0...iterations]
    output = _.template usTpl,
      paraMessage: "I'm a paragraph with some content inside."
      li1: "First List Item!"
      li2: "Second List Item!"
    temp = document.createElement('div')
    temp.innerHTML = output
    document.getElementById('fixture').appendChild temp.firstChild
  console.timeEnd('underscore')

  console.time('fragment')
  for i in [0...iterations]
    output = Fragment.parse frTpl,
      paraMessage: "I'm a paragraph with some content inside."
      li1: "First List Item!"
      li2: "Second List Item!"
    document.getElementById('fixture').appendChild output
  console.timeEnd('fragment')
