# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
google.load("gdata", "2.x", { packages: ["contacts", "calendar"] });

@User =
	GoogleInfos: {}
	Controllers: {
		edit: -> new User.EditController()
	}
	init: (controller)->
		this.Controller = this.Controllers[controller]()
		return this.Controller
		

class GoogleInfo extends Backbone.Model
	initialize: ->
		this.has_token = google.accounts.user.checkLogin( this.get('scope') );


class GoogleInfos extends Backbone.Collection
	model: GoogleInfo


generate_google_infos = ->
	User.GoogleInfos = new GoogleInfos([
		{ scope: 'https://www.google.com/m8/feeds', service: 'Contact' },
		{ scope: 'https://www.google.com/m8/feeds', service: 'Calendar' }
	])

	
test_infos = ->
	alert ( User.GoogleInfos.at(0).get('scope') )
	alert ( User.Controller.test  )


create_googleInfo_settings = ->
	generate_google_infos()
	test_infos()
	#This is where we render
	

class GoogleServicesView extends Backbone.View
	el: $("#google-apis-edit")

	events:
		"mouseenter el"  : "mouseEnter"
		"mouseleave el"  : "mouseLeave"
		
	mouseEnter : ->
		alert 'anything'
		
	mouseLeave : ->
		alert 'leaving'	


class User.EditController extends Backbone.Router
	initialize: -> 
		google.setOnLoadCallback( do -> create_googleInfo_settings )
	test: 'test stuff'	
