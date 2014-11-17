noXhrPatch = (typeof window != 'undefined' && !!window.ActiveXObject &&
  !(window.XMLHttpRequest && (new XMLHttpRequest).dispatchEvent))

methodMap = {
  'create': 'POST',
  'update': 'PUT',
  'patch':  'PATCH',
  'delete': 'DELETE',
  'read':   'GET'
}

addHeaderToRequest = (options, header, value)->
  beforeSend = options.beforeSend
  options.beforeSend = (xhr)->
    xhr.setRequestHeader(header, value)
    return beforeSend.apply(this, arguments) if beforeSend?

Backbone.sync = (method, model, options)->
  type = methodMap[method]

  _.defaults(options || (options = {}), {
    emulateHTTP: Backbone.emulateHTTP,
    emulateJSON: Backbone.emulateJSON
  })

  currentUser = WhitsonWedding.currentUser()
  accessToken = currentUser?.get('access_token')
  if accessToken?
    addHeaderToRequest(options, 'access_token', accessToken)
  
  params = {type: type, dataType: 'json'} 

  unless options.url
    params.url = _.result(model, 'url') || urlError()

  if (!options.data? && model && (method == 'create' || method == 'update' || method == 'patch'))
    params.contentType = 'application/json'
    # go in and out of JSON to maintain backwards compatibility
    attrsJSON = JSON.stringify(options.attrs || model.toJSON(options))
    attrs = _.extend(params.data || {}, JSON.parse(attrsJSON))
    params.data = JSON.stringify(attrs)

  if (options.emulateJSON)
    params.contentType = 'application/x-www-form-urlencoded'
    if params.data
      params.data = {model: params.data} 
    else 
      params.data = {}

  if (options.emulateHTTP && (type == 'PUT' || type == 'DELETE' || type == 'PATCH'))
    params.type = 'POST'
    if (options.emulateJSON) 
      params.data._method = type
    
    addHeaderToRequest(options, 'X-HTTP-Method-Override', type)

  if (params.type != 'GET' && !options.emulateJSON)
    params.processData = false

  if (params.type == 'PATCH' && noXhrPatch) 
    params.xhr = ->
      return new ActiveXObject("Microsoft.XMLHTTP")

  xhr = options.xhr = Backbone.ajax(_.extend(params, options))
  model.trigger('request', model, xhr, options)
  return xhr

