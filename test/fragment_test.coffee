root = exports ? this

assert = chai.assert

_ =
  f: (template,data) ->
    Fragment.parse(template,data)

  h: (fragment) ->
    div = document.createElement()
    div.appendChild(fragment)
    div.innerHTML

describe "Fragment", ->
  describe "API", ->
    it "should exist", ->
      assert.ok Fragment

    it "should respond to Fragment.parse", ->
      assert.ok Fragment.parse

  describe "Elements", ->
    it "should create a elements by tagName", ->
      f = _.f """
      p Hello World
      """
      assert.equal "P", f.firstChild.tagName

    it "should nest elements", ->
      f = _.f """
      p
        p Hello World
      """
      assert.equal "P", f.firstChild.tagName
      assert.equal "P", f.firstChild.firstChild.tagName
      assert.equal "Hello World", f.firstChild.firstChild.innerText

    it "should return ids for elements with #", ->
      f = _.f """
      p#test Hello
      """
      assert.equal "test", f.firstChild.id

    it "should return class for elements with .", ->
      f = _.f """
      p.test Hello
      """
      assert.equal "test", f.firstChild.className

    it "should return all class names with chained .", ->
      f = _.f """
      p.one.two.three Hello
      """
      assert.equal "one two three", f.firstChild.className

    it "should return both id and class names", ->
      f = _.f """
      p#test.one.two.three Hello
      """
      assert.equal "test", f.firstChild.id
      assert.equal "one two three", f.firstChild.className

    it "should return an empty element", ->
      f = _.f """
      p
      """
      assert.equal "P", f.firstChild.tagName

    it "should return div if no tagName is given", ->
      f = _.f """
      #test.one.two.three Hello
      """
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "test", f.firstChild.id
      assert.equal "one two three", f.firstChild.className

  describe "Interpolation", ->
    it "should evaluate data after =", ->
      f = _.f """
      div = this.message
      """, {message: "Hello World"}
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "Hello World", f.firstChild.innerText

    it "should evaluate an expression after =", ->
      f = _.f """
      div = this.a +" "+ this.b
      """, {a: "Hello", b: "World"}
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "Hello World", f.firstChild.innerText

    it "should return nodes after ==", ->
      p = document.createElement('p')
      f = _.f """
      == this.node
      """, {node: p}
      assert.strictEqual p, f.firstChild

    it "should allow use of @ instead of this.", ->
      f = _.f """
      p = @message
      """, {message: "Hello"}
      assert.equal "Hello", f.firstChild.innerText

    it "should allow use of more than one @", ->
      f = _.f """
      div = @a +" "+ @b
      """, {a: "Hello", b: "World"}
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "Hello World", f.firstChild.innerText

    it "should not replace @ in content", ->
      f = _.f """
      p hello@world.com
      """
      assert.equal "hello@world.com", f.firstChild.innerText

    it "should return nodes from function calls", ->
      f = _.f """
      == @myFunc()
      """,{myFunc:-> document.createElement('p')}
      assert.equal "P", f.firstChild.tagName

  describe "Attributes", ->

    it "should accept attributes as json behind a tag", ->
      f = _.f """
      p{"data-state": "Test"} Hello Attributes
      """
      assert.equal "P", f.firstChild.tagName
      assert.equal "Hello Attributes", f.firstChild.innerText
      assert.equal "Test", f.firstChild.dataset['state']

    it "should accept class and ID as json attributes", ->
      f = _.f """
      div{id:"test", class:"one two three"} Hello
      """
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "test", f.firstChild.id
      assert.equal "one two three", f.firstChild.className
      assert.equal "Hello", f.firstChild.innerText

    it "should mix shorthand and attributes", ->
      f = _.f """
      div.one.two.three{id: @myID()}
      """,{myID: -> "tester"}
      assert.equal "tester", f.firstChild.id
      assert.equal "one two three", f.firstChild.className

    it "should accept data as attributes", ->
      f = _.f """
      div{id: this.myID}
      """,{myID:"tester"}
      assert.equal "tester", f.firstChild.id

    it "should accept data as attributes using @", ->
      f = _.f """
      div{id: @myID}
      """,{myID:"tester"}
      assert.equal "tester", f.firstChild.id

    it "should evaluate data attribute functions", ->
      f = _.f """
      div{id: @myID()}
      """,{myID: -> "tester"}
      assert.equal "tester", f.firstChild.id

    it "should evaluate a reference when no key is given", ->
      f = _.f """
      div{@attributes} Example
      """,{attributes: {id: "tester", class: "test"}}
      assert.equal "tester", f.firstChild.id
      assert.equal "test", f.firstChild.className
      assert.equal "Example", f.firstChild.innerText

  describe "Formatting", ->
    it "should ignore anything that returns undefined on =", ->
      f = _.f """
      div = @myFunc()
      """,{myFunc:->undefined}
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "",f.firstChild.innerText

    it "should ignore anything that returns undefined on ==", ->
      f = _.f """
      div == @myFunc()
      """,{myFunc:->undefined}
      assert.equal "DIV", f.firstChild.tagName
      assert.equal "",f.firstChild.innerText

    it "should append whitespace after content starting with '", ->
      f = _.f """
      p
        ' Hello World!
      """
      assert.equal "Hello World! ", f.firstChild.innerText

    it "should allow HTML escaped entities", ->
      f = _.f """
      p &nbsp;1&nbsp;2&nbsp;3&nbsp;
      """
      assert.equal "\xA01\xA02\xA03\xA0", f.firstChild.innerText
