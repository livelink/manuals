class WelcomeController < ApplicationController
	def index
		@manuals = Manual.all(:limit => 10)
	end
end
