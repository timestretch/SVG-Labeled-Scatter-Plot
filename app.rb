require 'sinatra'
require './report'

class App < Sinatra::Base

	get '/' do

		data = []
		(0..25).each do |i|
			# [ x, y, label ]
			data << [i, (Math.sin(i/5.0) * 1000).to_i, (i+65).chr]
		end

		report = Report.new.render(data)

		erb :home, :locals => {:svg => report}

	end
end
