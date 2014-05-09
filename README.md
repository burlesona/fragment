Fragment
========

Fragment is a Javascript DSL for assembling HTML documents from
living DOM nodes.

**Why?**

Because when you have a deep hierarchy of views and subviews with
lots of complex events and they need to be dynamically added and
removed from the DOM frequently (ie - if you're building a one-page app),
you're going to eventually run into a lot of mess that comes from
keeping the hierarchy of subviews straight.

If you can create and insert real dom nodes directly in your templates,
this gets much easier.


Overview
--------

Unlike most templating systems, Fragment does not generate strings of HTML.
Instead, Fragment returns a DocumentFragment object, containing a tree of
elements generated in javascript. These elements are in-memory objects which
means they can already have events bound on them.

Fragment will evaluate variables or functions passed to a template, meaning
you can create view objects that return DOM nodes, and call them directly in
the template.


Usage
-----

Include fragment.js in your project, create a template, and call `Fragment.parse` on it.

It's a little nicer using Coffeescript, which has easier support for multi-line strings:

```
template = """
p I'm just a paragraph
p = @variable
p == @node()
"""

fragment = Fragment.parse template,
  variable: "I'm a variable!"
  node: ->
    b = document.createElement('button')
    b.innerText = "Click me!"
    b.addEventListener 'click', ->
      console.log "You clicked the button!"
    b

document.body.appendChild(fragment)
```


Syntax
------

Fragment uses a terse syntax similar to Slim (and Jade and Haml). However,
it is very minimal and completely logic-less.

Elements are defined with strings like this:
```
<selector>{<attributes>} <directive> <content>
```

### Selectors

You can define elements using CSS selectors. IE:

```
p Content -> <p>Content</p>
p.example Hello World -> <p class="example">Hello World</p>
.text I'm a div -> <div class="text">I'm a div</div>
#myID I've got an ID -> <div id="myID">I've got an ID</div>
```

### Attributes

You can pass a javascript object after a selector and it will be
evalulated and turned into attributes. For example:

```
h1{data-state:"awesome"} Awesome Headline! -> <h1 data-state="awesome">Awesome Headline!</h1>
```

### Directives and Content

There are four directives available:

- | creates a text node
- ' creates a text node with trailing whitespace
- = evaluates a property or function, expecting a string
- == evaluates a property or function, expecting a DOMElement

