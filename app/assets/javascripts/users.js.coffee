# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
google.load("gdata", "2.x", { packages: ["contacts", "calendar"] });

@User =
	GoogleInfos: {}
	BlocInfos: {}
	GdataServices:
		calendarService: null
	Controllers: 
		edit: -> new User.EditController()
		show: -> new User.ShowController()

	init: (controller)->
		this.Controller = this.Controllers[controller]()
		Backbone.history.start()
		return this.Controller
		

class GoogleInfo extends Backbone.Model
	initialize: ->
		@token = google.accounts.user.checkLogin( this.get('scope') );
	
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
		
		#contactsService = new google.gdata.contacts.ContactsService('blocs');
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
		
		$(this.el)
			.detach()
			.fadeOut 'fast', ->
			
				$(this_view.el).empty()
			
				_.each this_view.auth_service_views, (sV)->	
					$(this_view.el).append sV.render().el
			
				$(this_view.el)
					.appendTo(this_view.wrapper)
					.fadeIn('fast')
			
		return this	

#	
# Bloc infos and views 
#
	
class BlocInfo extends Backbone.Model
	initialize: ->
		# code	

class BlocInfos extends Backbone.Collection
	model: BlocInfo	


generate_bloc_infos = ->
	User.BlocInfos = new BlocInfos([ 
		{ 'test' : 'test' }
		{ 'best' : 'best' } 
		])

class BlocCalSignupView extends Backbone.View
	tagName: 'div'
	className: 'signup-wrapper'
	
	initialize: (options)->
		@markup = "<a>Add Blocs Calendar</a>"
		@wrapper = options.wrapper	
		
	events:
		'click a': 'link_event'	
		
	render: ->	
		$(this.el).empty()
		$(this.el).append(this.markup).appendTo(this.wrapper)
		
		return this
		
	link_event: ->
		# code to add calendar
		feedUri = 'https://www.google.com/calendar/feeds/default/owncalendars/full'
	
		calendar = new google.gdata.calendar.CalendarEntry()
		calendar.setTitle('Blocs')
		#cal_hidden = new google.gdata.calendar.HiddenProperty()
		#calendar.setHidden(calendar)
		
		callback = (result)=>
			alert 'calendar created.  check it out'
			
		handleError = (e)=>
			alert 'anything'	
		
		User.GdataServices.calendarService.insertEntry(feedUri, calendar, callback, handleError, google.gdata.calendar.CalendarEntry)
		
class _BlocView extends Backbone.View	
	tagName: 'div'
	
	render: ->
		$(this.el).empty()
		
		template = $.template('#blocTmpl')
					
		$.tmpl(template, this.model).appendTo(this.el)			
		
		return this
				
		
class BlocViews extends Backbone.View
	className: 'blocs-syndicate-container'
		
	initialize: (options)->
		this_view = this
		@wrapper = options.wrapper
		@child_view = options.child_view
		@bloc_views = []
		
		this.options.collection.each (bloc)-> #bloc is the model being passed around
			this_view.bloc_views.push( new this_view.child_view({
				model: bloc
				className: "should-be-associated-with-event"
			}))	
			
	render: =>
		$(this.el)
			.detach()
			.fadeOut 'fast', =>
			
				$(this.el).empty()
				
				this.generate_el_content()
				
				$(this.el)
					.appendTo(this.wrapper)
					.fadeIn('fast')
				
		return this
	
	generate_el_content: =>
		_.each this.bloc_views, (bV)=>
			$(this.el).append bV.render().el
			
	
		
#	
# User Controllers
#
class User.EditController extends Backbone.Router
	initialize: -> 
		generate_google_infos()
		
	routes:
		"" : "render_auth_views"
		
	render_auth_views: ->		
		googleServiceView = new GoogleServicesView
			child_view: GoogleServiceView
			collection: User.GoogleInfos
			wrapper: $('#google-apis-edit')
			tagName: 'div'
		googleServiceView.render()
	
	
class User.ShowController extends Backbone.Router
	
	initialize: ->
		generate_google_infos()
		@blocsView = null
		@sidebarWrapper = $('#blocs-sidebar-container')
		
		cal_info = User.GoogleInfos.find (info)->
			return info.get("service") == "Calendar" 
		
		# checking login token for calendar service.
		if !_.isEmpty cal_info.token then this.login_to_service()
		
	routes:
		"" : "root"
		
	root: ->
		# code	
	
	render_blocs: ->
		generate_bloc_infos()
		blocsView = new BlocViews
			child_view: _BlocView
			collection: User.BlocInfos
			wrapper: $('#blocs-sidebar-container')
			tagName: 'div'
		this.sidebarWrapper.empty()
		blocsView.render()
	
	render_blocs_cal_signup: ->
		blocCalSignup = new BlocCalSignupView
			wrapper: $('#blocs-sidebar-container')
		this.sidebarWrapper.empty()
		blocCalSignup.render()
	
	login_to_service: ->
		User.GdataServices.calendarService = new google.gdata.calendar.CalendarService 'blocs-calendar-0.1'

		feedUri = 'https://www.google.com/calendar/feeds/default/allcalendars/full'
		
		callback = (result)=>
			entries = result.feed.entry

			blocs_cal = _.detect entries, (entry)->
				entry.getTitle().getText() == 'Blocs'

			if _.isUndefined(blocs_cal) then this.render_blocs_cal_signup() else this.render_blocs()

		User.GdataServices.calendarService.getAllCalendarsFeed( feedUri, callback )
		

			
	
