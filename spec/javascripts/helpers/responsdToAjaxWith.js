var respondToMostRecentAjaxRequestWith = function(response) {
  return respondToMostRecentAjaxRequestWithCustom(200, response);
}

var respondToMostRecentAjaxRequestWithCustom = function(code, response) {
  request = jasmine.Ajax.requests.mostRecent();
  request.response({
        'status': code,
        'content/type': 'application/json',
        'responseText': JSON.stringify(response)
  });
  return request;
}
