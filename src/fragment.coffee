# NOTE: any Node inserted into the template can only happen once
# If a node is inserted a second time it will be moved, not cloned

# Global Scope
root = exports ? this

root.Fragment =
  parse: (template,data) ->
    lines = @_parseTemplate(template)
    tree = @_buildObjectTree(lines,0)
    @_buildDOMTree(tree,data)

  _parseTemplate: (template) ->
    lines = @_splitLines(template)
    @_readLine(line) for line in lines when line

  _splitLines: (text) ->
    text.split(/\r?\n/)

  _readLine: (string) ->
    [l,i,t,a,c] = string.match(/(\s*)([\w-\.#]*)?({.*})?\s?(.*)?/i)
    line = {}
    line.indent = (i.length/2)
    line.tagName = t if t
    line.attributes = @_prepare(a) if a
    line.content = @_parseContent(c) if c
    line

  _prepare: (string) ->
    safe = string.replace("@","this.")
    new Function("return #{safe};")

  _parseContent: (content) ->
    switch
      when r = content.match(/^=\s(.*)/)
        {type: 'expression', body: @_prepare(r[1])}
      when r = content.match(/^==\s(.*)/)
        {type: 'element', body: @_prepare(r[1])}
      when r = content.match(/^\|\s(.*)/)
        {type: 'string', body: r[1]}
      when r = content.match(/^\'\s(.*)/)
        {type: 'string', body: r[1]+" "}
      else
        {type: 'string', body: content}

  _buildObjectTree: (lines,depth) ->
    out = []
    while line = lines.shift()
      if line.indent < depth
        lines.unshift(line)
        break
      else if line.content
        out.push line
      else
        children = @_buildObjectTree(lines,line.indent + 1)
        line.children = children if children.length
        out.push line
    out

  _buildDOMTree: (tree,data) ->
    frag = document.createDocumentFragment()
    for obj in tree
      child = @_makeNode(obj,data)
      frag.appendChild child if child
    frag

  _makeNode: (obj,data) ->
    if obj.tagName
      node = @_makeElement(obj,data)
      if c = obj.content
        if c.type is 'string'
          node.innerHTML = c.body
        else if c.type is 'expression'
          result = c.body.call(data)
          node.innerHTML = result if result
        else if c.type is 'element'
          result = c.body.call(data)
          node.appendChild result if result
      if obj.children
        node.appendChild @_buildDOMTree(obj.children,data)

    else if c = obj.content
      if c.type is 'string'
        node = document.createTextNode c.body
      if c.type is 'expression'
        result = c.body.call(data)
        node = document.createTextNode result if result
      else if c.type is 'element'
        result = c.body.call(data)
        node = result if result

    node

  _makeElement: (obj,data) ->
    [string,tag,id,classes] = obj.tagName.match(/(^[\w-]+)?(#[\w-]+)?((?:\.[\w-]+)*)?/i)
    el = document.createElement(tag ? 'div')
    if id
      el.id = id.replace('#','')
    if classes
      el.className = classes.split('.').join(' ').trim()
    if obj.attributes
      el.setAttribute(k,v) for k,v of obj.attributes.call(data)
    el

