require 'rubygems'
require 'rufus/scheduler'  

scheduler = Rufus::Scheduler.new

#every day,
scheduler.every("1m") do

	#for all current cycles,
	Cycle.all.each do |cycle|
		if (Time.now.hour == cycle.morning_alert.hour || Time.now.hour == cycle.evening_alert.hour)
			if (cycle.start <= Date.today && cycle.end >= Date.today)
				#for each seed in this cycle and ending before the cycle ends,
				current_seeds = Array.new
				Seedtag.where(cycle_id: cycle.id).each do |seedtag|
					s = Seed.find(seedtag.seed_id)
					seed_length = (s.min_duration + s.max_duration) / 2
					if (seedtag.startdate.advance(:days => seed_length) < Date.today)
						seedtag.startdate = Date.today
					end
					if (seedtag.startdate.advance(:days => seed_length) < cycle.end)
						current_seeds.push(s.name)
					end
				end
				@current_seeds = current_seeds
				#put reminder at 10am
				p = Participant.all
				ParticipantMailer.welcome_email(p[Random.rand(p.length)], @current_seeds).deliver
			end
		end
	end
end

# scheduler.every("1d") do
# 	Seedtag.all.each do |seedtag|
# 		cycle = Cycle.find(seedtag.cycle_id)
# 		seed = Seed.find(seedtag.seed_id)
# 		if (cycle.start < Date.today && cycle.end > Date.today)
# 			# scheduler.every("10s") do
# 			# 	puts "#{seed.name}"
# 			# end
# 			scheduler.every()
# 		end
# 	end
# end

###############

# scheduler.every("1d") do

# scheduler.every("10s") do
#     JobThing.do_something
# end

# scheduler.in '20m' do
#   puts "order ristretto"
# end

# scheduler.at 'Thu Mar 26 07:31:43 +0900 2009' do
#   puts 'order pizza'
# end

# scheduler.cron '0 22 * * 1-5' do
#   # every day of the week at 22:00 (10pm)
#   puts 'activate security system'
# end

# scheduler.every '5m' do
#   puts 'check blood pressure'
# end