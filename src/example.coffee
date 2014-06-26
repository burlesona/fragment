root = exports ? this

template = """
h1
  ' Hello World
  small Meet Fragment

p
  ' Fragment is a dynamic, logic-less templating system that
  | converts a very terse syntax into living dom nodes.

p
  ' To use it, just include the <code>fragment.js</code> file
  ' in your project, then call:

pre
  code
    | Fragment.parse(templateString,dataObject)


p The syntax looks a lot like Slim or Jade. Define a node as follows:

pre
  code
    | &lt;selector>{&lt;attributes>} &lt;directive> &lt;content>

p You can define tags with CSS selectors like:

pre
  code
    | p#myID.firstClass.secondClass Howdy!

p You can skip the tag name for divs:

pre
  code
    | .classy I'm a classy div!
    br
    | div I'm a div with no class!

p
  | Control whitespace using ' or |:
  ul
    li = @pipeMessage
    li = @aposMessage

p
  ' You can use <code>=</code> at the beginning of a line, or after
  ' a selector to interpolate a property of the object you passed in.
  ' The code will be evaluated in the context of the object passed, so
  ' reference the properties with <code>this.property</code>.

pre
  code
    | = this.plainText
    br
    | p = this.textInsideParagraph

p
  ' If typing <code>this</code> isn't your favorite, you can use
  ' <code>@</code> instead, like CoffeeScript. (That's all from Coffee though.)

p
  ' The coolest feature, though, is this:
  ' You can create
  b living dom nodes&nbsp;
  ' and insert them into a template.
  ' These dom nodes will retain their event bindings,
  ' meaning you can declare your events on the node
  ' before rendering and they'll never get trashed
  ' in a re-render.

p == @node()

p Pretty cool huh? Now try this input:

== @input

p
  ' Both elements were generated in code and dynamically
  ' inserted into the template.
"""

root.init = ->
  input = document.createElement('input')
  input.type = "text"

  f = Fragment.parse template,
    pipeMessage: "| creates text nodes with no trailing space."
    aposMessage: "' creates text nodes with a trailing space."
    node: ->
      b = document.createElement('button')
      b.innerText = "Click me and check the console!"
      b.addEventListener 'click', ->
        console.log "You clicked my node!"
      b
    input: input

  root.myInput = input

  document.body.appendChild(f)
