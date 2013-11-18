window.App = Ember.Application.create()

if navigator.userAgent.match /(iPhone|iPod|iPad|Android|BlackBerry)/
    App.deferReadiness()
    document.addEventListener "deviceready", ->
        App.advanceReadiness()


App.Router.map ->
    @route 'new'
    @route 'manage'
    @route 'detail', { path: '/detail/:goal_id' }

#App.ApllicationRoute = Ember.Route.extend
#    actions:
#        linkTo: (route, param) ->
#            if param
#                this.transitionTo route, param
#            else
#                this.transitionTo route
