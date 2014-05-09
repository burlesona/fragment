// Generated by CoffeeScript 1.7.1
(function() {
  var assert, root, _;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  assert = chai.assert;

  _ = {
    f: function(template, data) {
      return Fragment.parse(template, data);
    },
    h: function(fragment) {
      var div;
      div = document.createElement();
      div.appendChild(fragment);
      return div.innerHTML;
    }
  };

  describe("Fragment", function() {
    it("should exist", function() {
      return assert.ok(Fragment);
    });
    it("should respond to Fragment.parse", function() {
      return assert.ok(Fragment.parse);
    });
    it("should create a elements by tagName", function() {
      var f;
      f = _.f("p Hello World");
      return assert.equal("P", f.firstChild.tagName);
    });
    it("should nest elements", function() {
      var f;
      f = _.f("p\n  p Hello World");
      assert.equal("P", f.firstChild.tagName);
      assert.equal("P", f.firstChild.firstChild.tagName);
      return assert.equal("Hello World", f.firstChild.firstChild.innerText);
    });
    it("should evaluate data after =", function() {
      var f;
      f = _.f("div = this.message", {
        message: "Hello World"
      });
      assert.equal("DIV", f.firstChild.tagName);
      return assert.equal("Hello World", f.firstChild.innerText);
    });
    it("should return nodes after ==", function() {
      var f, p;
      p = document.createElement('p');
      f = _.f("== this.node", {
        node: p
      });
      return assert.strictEqual(p, f.firstChild);
    });
    it("should return ids for elements with #", function() {
      var f;
      f = _.f("p#test Hello");
      return assert.equal("test", f.firstChild.id);
    });
    it("should return class for elements with .", function() {
      var f;
      f = _.f("p.test Hello");
      return assert.equal("test", f.firstChild.className);
    });
    it("should return all class names with chained .", function() {
      var f;
      f = _.f("p.one.two.three Hello");
      return assert.equal("one two three", f.firstChild.className);
    });
    it("should return both id and class names", function() {
      var f;
      f = _.f("p#test.one.two.three Hello");
      assert.equal("test", f.firstChild.id);
      return assert.equal("one two three", f.firstChild.className);
    });
    it("should return an empty element", function() {
      var f;
      f = _.f("p");
      return assert.equal("P", f.firstChild.tagName);
    });
    it("should return div if no tagName is given", function() {
      var f;
      f = _.f("#test.one.two.three Hello");
      assert.equal("DIV", f.firstChild.tagName);
      assert.equal("test", f.firstChild.id);
      return assert.equal("one two three", f.firstChild.className);
    });
    it("should allow use of @ instead of this.", function() {
      var f;
      f = _.f("p = @message", {
        message: "Hello"
      });
      return assert.equal("Hello", f.firstChild.innerText);
    });
    it("should not replace @ in content", function() {
      var f;
      f = _.f("p hello@world.com");
      return assert.equal("hello@world.com", f.firstChild.innerText);
    });
    it("should accept attributes as json behind a tag", function() {
      var f;
      f = _.f("p{\"data-state\": \"Test\"} Hello Attributes");
      assert.equal("P", f.firstChild.tagName);
      assert.equal("Hello Attributes", f.firstChild.innerText);
      return assert.equal("Test", f.firstChild.dataset['state']);
    });
    it("should accept class and ID as json attributes", function() {
      var f;
      f = _.f("div{id:\"test\", class:\"one two three\"} Hello");
      assert.equal("DIV", f.firstChild.tagName);
      assert.equal("test", f.firstChild.id);
      assert.equal("one two three", f.firstChild.className);
      return assert.equal("Hello", f.firstChild.innerText);
    });
    it("should accept data as attributes", function() {
      var f;
      f = _.f("div{id: this.myID}", {
        myID: "tester"
      });
      return assert.equal("tester", f.firstChild.id);
    });
    it("should accept data as attributes using @", function() {
      var f;
      f = _.f("div{id: @myID}", {
        myID: "tester"
      });
      return assert.equal("tester", f.firstChild.id);
    });
    it("should evaluate data attribute functions", function() {
      var f;
      f = _.f("div{id: @myID()}", {
        myID: function() {
          return "tester";
        }
      });
      return assert.equal("tester", f.firstChild.id);
    });
    it("should mix shorthand and attributes", function() {
      var f;
      f = _.f("div.one.two.three{id: @myID()}", {
        myID: function() {
          return "tester";
        }
      });
      assert.equal("tester", f.firstChild.id);
      return assert.equal("one two three", f.firstChild.className);
    });
    it("should ignore anything that returns undefined on =", function() {
      var f;
      f = _.f("div = @myFunc()", {
        myFunc: function() {
          return void 0;
        }
      });
      assert.equal("DIV", f.firstChild.tagName);
      return assert.equal("", f.firstChild.innerText);
    });
    it("should ignore anything that returns undefined on ==", function() {
      var f;
      f = _.f("div == @myFunc()", {
        myFunc: function() {
          return void 0;
        }
      });
      assert.equal("DIV", f.firstChild.tagName);
      return assert.equal("", f.firstChild.innerText);
    });
    return it("should return nodes from function calls", function() {
      var f;
      f = _.f("== @myFunc()", {
        myFunc: function() {
          return document.createElement('p');
        }
      });
      return assert.equal("P", f.firstChild.tagName);
    });
  });

}).call(this);
