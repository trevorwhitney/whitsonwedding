var createView = function(templateName) {
  return Backbone.View.extend({
    el: "#content",
    template: JST[templateName],
    initialize: function (options) {
      this.$el = $(this.el);
    },
    render: function () {
      this.$el.html(this.template());
    }
  });

}

var WhitsonWeddingRouter = Backbone.Router.extend({
  routes: {
    "": "index",
    "where-to-stay": "whereToStay",
    "things-to-do": "thingsToDo",
    "getting-to-ouray": "gettingToOuray",
    "wedding-day": "weddingDay"
  },
  index: function () {
    var IndexView = createView('index');
    var index = new IndexView();
    index.render();
  },
  whereToStay: function (query, page) {
    var WhereToStayView = createView('whereToStay');
    var whereToStay = new WhereToStayView();
    whereToStay.render();
  },
  thingsToDo: function (query, page) {
    var ThingsToDoView = createView('thingsToDo');
    var thingsToDo = new ThingsToDoView();
    thingsToDo.render();
  },
  gettingToOuray: function (query, page) {
    var GettingToOurayView = createView('gettingToOuray');
    var gettingToOuray = new GettingToOurayView();
    gettingToOuray.render();
  },
  weddingDay: function (query, page) {
    var WeddingDayView = createView('weddingDay');
    var weddingDay = new WeddingDayView();
    weddingDay.render();
  }
});

var closeDropdown = function(event) {
  $('.dropdown.open .dropdown-toggle').dropdown('toggle');
};

$(function () {
  window.router = new WhitsonWeddingRouter;
  Backbone.history.start({pushState: true});
  $(document).on("click", "a[href^='/']", function(event) {
    href = $(event.currentTarget).attr('href');

    passThrough = href.indexOf('sign_out') >= 0;

    if (!passThrough && !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey) {
      event.preventDefault();
      closeDropdown(event);

      url = href.replace(/^\//,'').replace('\#\!\/','');
        window.router.navigate(url, { trigger: true });

      return false;
    }
  });
});
