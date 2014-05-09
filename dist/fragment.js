// Generated by CoffeeScript 1.7.1
(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.Fragment = {
    parse: function(template, data) {
      var frag, objLines, rawLines, tree;
      rawLines = this._splitLines(template);
      objLines = this._readLines(rawLines);
      tree = this._buildObjectTree(objLines, 0);
      return frag = this._buildDOMTree(tree, data);
    },
    _splitLines: function(text) {
      return text.split(/\r?\n/);
    },
    _readLines: function(lines) {
      var line, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = lines.length; _i < _len; _i++) {
        line = lines[_i];
        if (line) {
          _results.push(this._readLine(line));
        }
      }
      return _results;
    },
    _readLine: function(string) {
      var a, c, i, l, line, t, _ref;
      _ref = string.match(/(\s*)([\w-\.#]*)?({.*})?\s?(.*)?/i), l = _ref[0], i = _ref[1], t = _ref[2], a = _ref[3], c = _ref[4];
      line = {
        indent: i.length / 2,
        tagName: t,
        attributes: this._replaceAt(a),
        content: this._replaceAt(c)
      };
      return line;
    },
    _replaceAt: function(string) {
      if (string) {
        return string.replace("@", "this.");
      }
    },
    _buildObjectTree: function(objLines, depth) {
      var children, line, out;
      out = [];
      while (line = objLines.shift()) {
        if (line.indent < depth) {
          objLines.unshift(line);
          break;
        } else if (line.content) {
          out.push(line);
        } else {
          children = this._buildObjectTree(objLines, line.indent + 1);
          if (children.length) {
            line.children = children;
          }
          out.push(line);
        }
      }
      return out;
    },
    _buildDOMTree: function(objTree, data) {
      var child, frag, obj, _i, _len;
      frag = document.createDocumentFragment();
      for (_i = 0, _len = objTree.length; _i < _len; _i++) {
        obj = objTree[_i];
        child = this._makeNode(obj, data);
        if (child) {
          frag.appendChild(child);
        }
      }
      return frag;
    },
    _makeNode: function(obj, data) {
      var c, expr, node, result;
      if (obj.tagName) {
        node = this._parseElement(obj.tagName, obj.attributes, data);
        if (obj.content) {
          c = this._parseContent(obj.content);
          if (c.type === 'string') {
            node.innerHTML = c.body;
          } else if (c.type === 'expression') {
            expr = new Function("return " + c.body);
            result = expr.call(data);
            if (result) {
              node.innerHTML = result;
            }
          } else if (c.type === 'element') {
            expr = new Function("return " + c.body);
            result = expr.call(data);
            if (result) {
              node.appendChild(result);
            }
          }
        }
        if (obj.children) {
          node.appendChild(this._buildDOMTree(obj.children, data));
        }
      } else {
        c = this._parseContent(obj.content);
        if (c.type === 'string') {
          node = document.createTextNode(c.body);
        }
        if (c.type === 'expression') {
          expr = new Function("return " + c.body);
          result = expr.call(data);
          if (result) {
            node = document.createTextNode(result);
          }
        } else if (c.type === 'element') {
          expr = new Function("return " + c.body);
          result = expr.call(data);
          if (result) {
            node = result;
          }
        }
      }
      return node;
    },
    _parseElement: function(tagName, attributes, data) {
      var classes, el, id, k, parsed, r, string, tag, v;
      r = tagName.match(/(^[\w-]+)?(#[\w-]+)?((?:\.[\w-]+)*)?/i);
      string = r[0], tag = r[1], id = r[2], classes = r[3];
      if (tag == null) {
        tag = 'div';
      }
      if (classes) {
        classes = classes.split('.').join(' ').trim();
      }
      if (id) {
        id = id.replace('#', '');
      }
      el = document.createElement(tag);
      if (id) {
        el.id = id;
      }
      if (classes) {
        el.className = classes;
      }
      if (parsed = this._parseAttributes(attributes, data)) {
        for (k in parsed) {
          v = parsed[k];
          el.setAttribute(k, v);
        }
      }
      return el;
    },
    _parseAttributes: function(attributes, data) {
      var expr;
      if (attributes) {
        expr = new Function("return " + attributes + ";");
        return expr.call(data);
      }
    },
    _parseContent: function(content) {
      var r;
      switch (false) {
        case !(r = content.match(/^=\s(.*)/)):
          return {
            type: 'expression',
            body: r[1]
          };
        case !(r = content.match(/^==\s(.*)/)):
          return {
            type: 'element',
            body: r[1]
          };
        case !(r = content.match(/^\|\s(.*)/)):
          return {
            type: 'string',
            body: r[1] + " "
          };
        default:
          return {
            type: 'string',
            body: content
          };
      }
    }
  };

}).call(this);