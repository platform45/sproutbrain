class Cycle < ActiveRecord::Base

	belongs_to :project
	has_many :seedtags, dependent: :destroy

	def slack_sprout_alert(participant, seeds)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   # :text => "#{participant.email}: Alert from your sprouts!",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "#{participant.email}: Alert from your sprouts!",
										      	:value => "We need water! This is a reminder that you need to rinse us (#{seeds}) in cool water, and place the jars back facing down."}]
										}])

		RestClient.post("https://slack.com/api/chat.postMessage",
			    {:token => "xoxp-2169285463-2474192020-2505203050-5a8c2a",
			     :channel => "#sproutbrain",
			     :username => "Sproutbrain",
			     :attachments => slack_attachment,
			     :unfurl_links => 1,
			     :icon_url => "http://sr.photos3.fotosearch.com/bthumb/UNC/UNC212/u12257815.jpg",
			     :pretty => "1"
			    })
	end

	def slack_cycle_alert(user)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   # :text => "Time to take care of the sprouts!",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "#{user.email}: Cycle is about to expire...",
										      	:value => "Your cycle is about to expire! That means you won't be watering us and we're sad:( Please go to www.sproutbrain.com and adjust the start date of your cycle!"}]
										}])

		RestClient.post("https://slack.com/api/chat.postMessage",
			    {:token => "xoxp-2169285463-2474192020-2505203050-5a8c2a",
			     :channel => "#sproutbrain",
			     :username => "Sproutbrain",
			     :attachments => slack_attachment,
			     :unfurl_links => 1,
			     :icon_url => "http://sr.photos3.fotosearch.com/bthumb/UNC/UNC212/u12257815.jpg",
			     :pretty => "1"
			    })
	end	

	def repeat_cycle
		Cycle.all.each do |cycle|
			#if current hour is the morning/evening alert hour, (-2 is because heroku counts UTC time)
			if (Time.now.hour == (cycle.morning_alert.hour) || Time.now.hour == (cycle.evening_alert.hour))
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
					@current_seeds = @current_seeds.to_sentence
					#send email
					p = Participant.all
					lucky_participant = p[Random.rand(p.length)]
					ParticipantMailer.sprout_alert(lucky_participant, @current_seeds).deliver
					cycle.slack_sprout_alert(lucky_participant, @current_seeds)
					if (cycle.end == Date.today && Time.now.hour == (cycle.evening_alert.hour))
						ParticipantMailer.cycle_alert(current_user, cycle, cycle.start).deliver
						cycle.slack_cycle_alert(current_user)
					end
				end
			end
		end
	end

end