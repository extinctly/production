# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://extinct.ly"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
			]

			# The default title of our website
			title: "EXTINCT.LY"

			# The website description (for SEO)
			description: """
				EXTINCT.LY is an ongoing commissioning and research platform developed to support remote participation in the Serpentine Galleries’ 2014 Extinction Marathon: Visions of the Future.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				serpentine galleries, extinction marathon
				"""

			# The website author's name
			author: "Kei Kreutler"

			# The website author's email
			email: "kei@ourmachine.net"

			# Styles
			styles: [
				"//api.tiles.mapbox.com/mapbox.js/v2.1.0/mapbox.css"
				"//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css"
				"/styles/bootstrap-custom.css"
				"/styles/extinctly.css"
			]

			# Scripts
			scripts: [
				"//ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"
				"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js"
				"//cdn.firebase.com/js/client/1.0.15/firebase.js"
				"/scripts/bootstrap-custom.js"
				"/scripts/modal.js"
				"/scripts/script.js"
				"//api.tiles.mapbox.com/mapbox.js/v2.0.1/mapbox.js"
				"/vendor/js/leaflet.ajax.min.js"
				"/scripts/contact.js"
				"/scripts/map.js"
				"/scripts/dashboard.js"
			]



		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:

		navbar: ->
            @getCollection("html").findAllLive({isPage:true},[{order:1}])

		case_studies: ->
            @getCollection("html").findAllLive({isCaseStudy:true})

		participants: ->
            @getCollection("html").findAllLive({isParticipant:true})

		hasVideo: ->
            @getCollection("html").findAllLive({isVideo:true})

		hasSubdomain: ->
            @getCollection("html").findAllLive({isSubdomain:true})

		extinction_sites: ->
            @getCollection("html").findAllLive({isExtinctionSite:true})

		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: (database) ->
			database.findAllLive({tags:$has:'post'}, [date:-1])


	# =================================
	# Plugins

	plugins:
		ghpages:
        	deployRemote: 'target'
        	deployBranch: 'master'


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}


# Export our DocPad Configuration
module.exports = docpadConfig
