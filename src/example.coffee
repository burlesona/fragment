root = exports ? this

template = """
h1{"data-test":"example"}
  ' Hello World
  small Meet Fragment

p
  ' Fragment is a dynamic, logic-less templating system that
  | converts a very terse syntax into living dom nodes.

p
  | Control whitespace using ' or |:
  ul
    li = @pipeMessage
    li = @aposMessage

p The syntax looks a lot like Slim or Jade. define a node as follows:

code
  | <selector>{<attributes>} <directive> <content>

p You can define tags with CSS selectors like:

code
  | p#myID.firstClass.secondClass Howdy!

p You can skip the tag name for divs:

code
  | .classy I'm a classy div!
  br
  | div I'm a div with no class!

.nodes
  p
    ' My coolest feature, though, is this:
    ' You can create
    b living dom nodes&nbsp;
    ' and insert them into a template.
    ' These dom nodes will retain their event bindings,
    ' meaning you can declare your events on the node
    ' before rendering and they'll never get trashed
    ' in a re-render.

  p == @node()

  p Pretty cool huh?
"""

root.init = ->
  f = Fragment.parse template,
    pipeMessage: "| creates text nodes with no trailing space."
    aposMessage: "' creates text nodes with a trailing space."
    node: ->
      b = document.createElement('button')
      b.innerText = "Click me and check the console!"
      b.addEventListener 'click', ->
        console.log "You clicked my node!"
      b

  document.body.appendChild(f)
