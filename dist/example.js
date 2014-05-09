// Generated by CoffeeScript 1.7.1
(function() {
  var root, template;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  template = "h1{\"data-test\":\"example\"}\n  ' Hello World\n  small Meet Fragment\n\np\n  ' Fragment is a dynamic, logic-less templating system that\n  | converts a very terse syntax into living dom nodes.\n\np\n  | Control whitespace using ' or |:\n  ul\n    li = @pipeMessage\n    li = @aposMessage\n\np The syntax looks a lot like Slim or Jade. define a node as follows:\n\ncode\n  | <selector>{<attributes>} <directive> <content>\n\np You can define tags with CSS selectors like:\n\ncode\n  | p#myID.firstClass.secondClass Howdy!\n\np You can skip the tag name for divs:\n\ncode\n  | .classy I'm a classy div!\n  br\n  | div I'm a div with no class!\n\n.nodes\n  p\n    ' My coolest feature, though, is this:\n    ' You can create\n    b living dom nodes&nbsp;\n    ' and insert them into a template.\n    ' These dom nodes will retain their event bindings,\n    ' meaning you can declare your events on the node\n    ' before rendering and they'll never get trashed\n    ' in a re-render.\n\n  p == @node()\n\n  p Pretty cool huh?";

  root.init = function() {
    var f;
    f = Fragment.parse(template, {
      pipeMessage: "| creates text nodes with no trailing space.",
      aposMessage: "' creates text nodes with a trailing space.",
      node: function() {
        var b;
        b = document.createElement('button');
        b.innerText = "Click me and check the console!";
        b.addEventListener('click', function() {
          return console.log("You clicked my node!");
        });
        return b;
      }
    });
    return document.body.appendChild(f);
  };

}).call(this);
