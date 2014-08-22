# this scheduler is run by heroku scheduler addon (controlled on heroku dashboard)
desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
    Cycle.all.each do |cycle|
		#if current hour is the morning/evening alert hour, (-2 is because heroku counts UTC time)
		if (Time.now.utc.hour == (cycle.morning_alert.hour - 2) || Time.now.utc.hour == (cycle.evening_alert.hour - 2))
			#if today is a valid date for the cycle,
			if (cycle.start <= Date.today && cycle.end >= Date.today)
				#for each seed in this cycle and ending before the cycle ends,
				current_seeds = Array.new
				Seedtag.where(cycle_id: cycle.id).each do |seedtag|
					s = Seed.find(seedtag.seed_id)
					# this part is for filtering seeds that will likely not sprout before cycle end
					# seed_length = (s.min_duration + s.max_duration) / 2
					# if (seedtag.startdate.advance(:days => seed_length - 1) < Date.today)
					# 	seedtag.startdate = Date.today
					# end
					# if (seedtag.startdate.advance(:days => seed_length - 1) <= cycle.end)
					# 	current_seeds.push(s.name)
					# end
					# comment this line below if above lines are uncommented
					current_seeds.push(s.name)
				end
				@current_seeds = current_seeds
				@current_seeds = @current_seeds.to_sentence
				#send email
				p = Participant.where(project_id: cycle.project_id)
				lucky_participant = p[Random.rand(0..(p.length-1))]
				@fact = cycle.get_facts
				if (cycle.start == Date.today)
					ParticipantMailer.first_alert(lucky_participant, @fact).deliver
					cycle.slack_first_alert(lucky_participant)
				else
					ParticipantMailer.sprout_alert(lucky_participant, @current_seeds, @fact).deliver
					cycle.slack_sprout_alert(lucky_participant, @current_seeds)
					if (cycle.end == Date.today && Time.now.utc.hour == (cycle.evening_alert.hour - 2))
						current_user = User.find(Project.find(cycle.project_id).user_id)
						ParticipantMailer.cycle_alert(current_user, cycle, cycle.start).deliver
						cycle.slack_cycle_alert(current_user)
					end
				end
			end
		end
	end
end