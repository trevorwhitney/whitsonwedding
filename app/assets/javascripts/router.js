var createView = function(templateName) {
  return Backbone.View.extend({
    el: "#content",
    template: JST[templateName],
    initialize: function (options) {
      this.$el = $(this.el);
    },
    render: function (data) {
      this.$el.html(this.template(data));
    }
  });

}

var WhitsonWeddingRouter = Backbone.Router.extend({
  routes: {
    "": "index",
    "where-to-stay": "whereToStay",
    "things-to-do": "thingsToDo",
    "secret-garden": "weddingDay",
    "getting-to-ouray": "gettingToOuray",
    "registry": "registry",
    "thursday": "thursday",
    "friday": "friday",
    "wedding-day": "weddingDay",
    "officiant": "officiant",
    "wedding-party": "weddingParty",
    "amanda-and-trevor": "amandaAndTrevor",
    "rsvp": "rsvp"
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
  },
  thursday: function (query, page) {
    var ThursdayView = createView('thursday');
    var thursday = new ThursdayView();
    thursday.render();
  },
  friday: function (query, page) {
    var FridayView = createView('friday');
    var friday = new FridayView();
    friday.render();
  },
  weddingDay: function (query, page) {
    var WeddingDayView = createView('weddingDay');
    var weddingDay = new WeddingDayView();
    weddingDay.render();
  },
  registry: function (query, page) {
    var RegistryView = createView('registry');
    var registry = new RegistryView();
    registry.render();
  },
  officiant: function (query, page) {
    var OfficiantView = createView('officiant');
    var officiant = new OfficiantView();
    officiant.render();
  },
  weddingParty: function (query, page) {
    var WeddingPartyView = createView('weddingParty');
    var weddingParty = new WeddingPartyView();
    weddingParty.render();
  },
  amandaAndTrevor: function (query, page) {
    var AmandaAndTrevor = createView('amandaAndTrevor');
    var amandaAndTrevor = new AmandaAndTrevor();
    amandaAndTrevor.render({pictures: WhitsonWedding.Assets.Pictures});
  },
  rsvp: function (query, page) {
    if (!WhitsonWedding.currentUser()) {
      this.navigate('/', {trigger: true});
      return;
    }
    var guestList = new WhitsonWedding.Views.GuestList();
    guestList.render();
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

    passThrough = (href.indexOf('sign_out') >= 0) || (href.indexOf('admin') >= 0);

    if (!passThrough && !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey) {
      event.preventDefault();
      closeDropdown(event);

      url = href.replace(/^\//,'').replace('\#\!\/','');
        window.router.navigate(url, { trigger: true });

      return false;
    }
  });
  WhitsonWedding.Assets.Pictures = [];
  var pictures = [
    {src: "/assets/engagement/1.jpg"},
    {src: "/assets/engagement/2.jpg"},
    {src: "/assets/engagement/3.jpg"},
    {src: "/assets/engagement/4.jpg"},
    {src: "/assets/engagement/5.jpg"},
    {src: "/assets/engagement/6.jpg"},
    {src: "/assets/engagement/7.jpg"},
    {src: "/assets/engagement/8.jpg"},
    {src: "/assets/engagement/9.jpg"},
    {src: "/assets/engagement/10.jpg"},
    {src: "/assets/engagement/11.jpg"}
  ];

  pictures.forEach(function (picture) {
    console.log(picture);
    var image = new Image();
    image.src = picture.src;
    WhitsonWedding.Assets.Pictures.push(image);
  });
});
