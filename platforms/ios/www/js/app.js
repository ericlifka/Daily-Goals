App = Ember.Application.create();

//App.deferReadiness();
//document.addEventListener("deviceready", function () {
//    App.advanceReadiness();
//}, false);

App.Router.map(function () {
    // put your routes here
});

App.IndexRoute = Ember.Route.extend({
    model: function () {
        return ['red', 'yellow', 'blue'];
    }
});

