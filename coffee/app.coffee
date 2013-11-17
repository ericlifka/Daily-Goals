window.App = Ember.Application.create()

if navigator.userAgent.match /(iPhone|iPod|iPad|Android|BlackBerry)/
    App.deferReadiness()
    document.addEventListener "deviceready", ->
        App.advanceReadiness()


App.Router.map ->
    @route 'new'
    @route 'manage'
