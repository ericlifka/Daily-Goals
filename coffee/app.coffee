window.App = Ember.Application.create()
#
#App.deferReadiness()
#document.addEventListener "deviceready", ->
#    App.advanceReadiness()

App.Router.map ->
    this.route 'new'
