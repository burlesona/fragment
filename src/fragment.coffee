# NOTE: any Node inserted into the template can only happen once
# If a node is inserted a second time it will be moved, not cloned

# Global Scope
root = exports ? this

root.Fragment =
  parse: (template,data) ->
    rawLines = @_splitLines(template)
    objLines = @_readLines(rawLines)
    tree = @_buildObjectTree(objLines,0)
    frag = @_buildDOMTree(tree,data)

  _splitLines: (text) ->
    text.split(/\r?\n/)

  _readLines: (lines) ->
    @_readLine(line) for line in lines when line

  _readLine: (string) ->
    [l,i,t,a,c] = string.match(/(\s*)([\w-\.#]*)?({.*})?\s?(.*)?/i)
    line = {indent: (i.length/2), tagName: t, attributes: @_replaceAt(a), content: @_replaceAt(c)}
    #console.log 'readline return:',line
    line

  _replaceAt: (string) ->
    string.replace("@","this.") if string

  _buildObjectTree: (objLines,depth) ->
    out = []
    while line = objLines.shift()
      if line.indent < depth
        objLines.unshift(line)
        break
      else if line.content
        out.push line
      else
        children = @_buildObjectTree(objLines,line.indent + 1)
        line.children = children if children.length
        out.push line
    out

  _buildDOMTree: (objTree,data) ->
    frag = document.createDocumentFragment()
    for obj in objTree
      child = @_makeNode(obj,data)
      frag.appendChild child if child
    frag

  # TODO:
  # REFACTOR THIS BIT
  _makeNode: (obj,data) ->
    if obj.tagName
      node = @_parseElement(obj.tagName,obj.attributes,data)
      if obj.content
        c = @_parseContent(obj.content)
        if c.type is 'string'
          node.innerHTML = c.body
        else if c.type is 'expression'
          expr = new Function("return #{c.body}")
          result = expr.call(data)
          node.innerHTML = result if result
        else if c.type is 'element'
          expr = new Function("return #{c.body}")
          result = expr.call(data)
          node.appendChild result if result
      if obj.children
        node.appendChild @_buildDOMTree(obj.children,data)

    else
      c = @_parseContent(obj.content)
      #console.log 'parse content result:',c
      if c.type is 'string'
        node = document.createTextNode c.body
      if c.type is 'expression'
        expr = new Function("return #{c.body}")
        result = expr.call(data)
        node = document.createTextNode result if result
      else if c.type is 'element'
        expr = new Function("return #{c.body}")
        result = expr.call(data)
        node = result if result

    #console.log "MakeNode return:", node
    node

  _parseElement: (tagName,attributes,data) ->
    #console.log "_parseElement tagName:",tagName
    r = tagName.match(/(^[\w-]+)?(#[\w-]+)?((?:\.[\w-]+)*)?/i)
    #console.log "_parseElement return:",r
    [string,tag,id,classes] = r
    tag ?= 'div'
    classes = classes.split('.').join(' ').trim() if classes
    id = id.replace('#','') if id
    el = document.createElement(tag)
    el.id = id if id
    el.className = classes if classes
    if parsed = @_parseAttributes(attributes,data)
      el.setAttribute(k,v) for k,v of parsed
    el

  _parseAttributes: (attributes,data) ->
    if attributes
      expr = new Function("return #{attributes};")
      expr.call(data)

  _parseContent: (content) ->
    switch
      when r = content.match(/^=\s(.*)/)
        {type: 'expression', body: r[1]}
      when r = content.match(/^==\s(.*)/)
        {type: 'element', body: r[1]}
      when r = content.match(/^\|\s(.*)/)
        {type: 'string', body: r[1]+" "}
      else
        {type: 'string', body:content}
