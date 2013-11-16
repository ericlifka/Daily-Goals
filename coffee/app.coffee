window.App = Ember.Application.create()


App.deferReadiness()
document.addEventListener "deviceready", ->
    App.advanceReadiness()


App.Router.map ->
    @route 'new'
    @route 'manage'
