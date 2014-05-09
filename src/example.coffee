root = exports ? this

template = """
h1{"data-test":"example"} Hello World

p
  ' I'm an example of some content.
  = @message

.test
  ' I can have strings inside

.one
  .two
    .three
      p Or be deeply nested
"""

root.init = ->
  f = Fragment.parse(template, message: "Hello Interpolation!")
  document.body.appendChild(f)
