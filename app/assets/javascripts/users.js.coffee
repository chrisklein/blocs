# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



google.load("gdata", "2.x", { packages: ["contacts", "calendar"] });

class GoogleInfo
	constructor: (scope) ->
		@scope = scope
		@has_token = google.accounts.user.checkLogin(scope).length > 0?;	
		
		
		
class UserController extends Backbone.Router
		
	authorize_contacts	: ->
		alert(GoogleInfo.has_token)
		if GoogleInfo.has_token then alert "authorizing contacts"


google.setOnLoadCallback( create_googleInfo() )

create_googleInfo = ->
	@GoogleInfo = GoogleInfo('https://www.google.com/m8/feeds') 
	
@UserController = new UserController()
Backbone.history.start();
