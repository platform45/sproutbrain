class Repeat < ActiveRecord::Base
	def send_alerts
		Cycle.all.each do |cycle|
			#if current hour is the morning/evening alert hour,
			if (Time.now.hour == cycle.morning_alert.hour || Time.now.hour == cycle.evening_alert.hour)
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
					ParticipantMailer.welcome_email(p[Random.rand(p.length)], @current_seeds).deliver
				end
			end
		end
		self.delay(:run_at => 1.minute.from_now).send_alerts
	end

	def self.start_me_up
        new.seld_alerts
    end
end
