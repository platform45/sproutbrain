# this scheduler is run by heroku scheduler addon (controlled on heroku dashboard)
desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
    # for all current cycles,
	Cycle.all.each do |cycle|
		#if current hour is the morning/evening alert hour, (-2 is because heroku counts UTC time)
		if (Time.now.hour == (cycle.morning_alert.hour - 2) || Time.now.hour == (cycle.evening_alert.hour - 2))
			#if today is a valid date for the cycle,
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
				#send email
				p = Participant.all
				ParticipantMailer.sprout_alert(p[Random.rand(p.length)], @current_seeds).deliver
				if (cycle.end == Date.today && Time.now.hour == (cycle.evening_alert.hour - 2))
					ParticipantMailer.cycle_alert(current_user, cycle, cycle.start).deliver
				end
			end
		end
	end
end