# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
google.load("gdata", "2.x", { packages: ["contacts", "calendar"] });

@User =
	GoogleInfos: {}
	Controllers: 
		edit: -> new User.EditController()

	init: (controller)->
		this.Controller = this.Controllers[controller]()
		return this.Controller
		

class GoogleInfo extends Backbone.Model
	initialize: ->
		@token = google.accounts.user.checkLogin( this.get('scope') );
		#@has_token = 'string_name'
	
	# Convenience method for refreshing google token in Model
	refresh_token: ->
		@token = google.accounts.user.checkLogin( this.get('scope') );	


class GoogleInfos extends Backbone.Collection
	model: GoogleInfo


generate_google_infos = ->
	User.GoogleInfos = new GoogleInfos([
		{ scope: 'https://www.google.com/m8/feeds', service: 'Contacts' },
		{ scope: 'https://www.google.com/calendar/feeds', service: 'Calendar' }
	])		

create_googleInfo_settings = ->
	generate_google_infos()
	googleServiceView = new GoogleServicesView
		child_view: GoogleServiceView
		collection: User.GoogleInfos
		wrapper: $('#google-apis-edit')
		tagName: 'div'
	googleServiceView.render()
	

class GoogleServiceView extends Backbone.View
	tagName:    'div'
	
	initialize: ->
		_.bindAll this, 'render', 'link_event', 'logout_of_service'
		this.model.bind 'change', this.render
		this.model.view = this
	
	events:
		'click a': 'link_event'
	
	render: ->
		
		# Empty the div first 
		$(this.el).empty()
		
		add_info = this.generate_additional_info()
		
		template = $.template('#googleAuthTmpl')
					
		$.tmpl(template, this.model,
			add_info
		).appendTo(this.el)			
		
		return this
	
	generate_additional_info: ->
		if !_.isEmpty this.model.token then {
			link_text: 'Logout'
			label_text: 'Logout of Google '+this.model.get('service')
			link_action: 'login-to-'+this.model.get('service').toLowerCase()
		} else {
			link_text: 'Login'
			label_text: 'Login to Google '+this.model.get('service')
			link_action: 'logout-of-'+this.model.get('service').toLowerCase()
		}	
		
	link_event: ->
		if _.isEmpty this.model.token then this.login_to_service() else this.logout_of_service()
	
			
	login_to_service: ->
		#contactsService = new google.gdata.contacts.ContactsService('blocks');
		google.accounts.user.login( this.model.get('scope') );
		
	logout_of_service: ->	
		google.accounts.user.logout()	
		this.model.refresh_token()
		this.model.change()

class GoogleServicesView extends Backbone.View
	
	initialize: (options)->
		this_view = this
		@wrapper = options.wrapper
		@child_view = options.child_view
		@auth_service_views = []
		
		this.options.collection.each (service)-> # service represents the model
			this_view.auth_service_views.push( new this_view.child_view({ 
				model: service 
				className: 'google-'+service.get('service').toLowerCase()+'-'+service.cid
			}) )
			
	render: ->
		this_view = this
		
		$(this.el).fadeOut 'fast', ->
			
			$(this_view.el).empty()
			
			_.each this_view.auth_service_views, (sV)->	
				$(this_view.el).append sV.render().el
			
			$(this_view.el)
				.appendTo(this_view.wrapper)
				.fadeIn('fast')
			
		return this	
	

class User.EditController extends Backbone.Router
	initialize: -> 
		google.setOnLoadCallback do -> create_googleInfo_settings
	
	
	
	
