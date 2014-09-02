class PagesController < ApplicationController
	def about
		render layout: "homepage.html.erb"
	end

	def usage
		render layout: "homepage.html.erb"
	end
end