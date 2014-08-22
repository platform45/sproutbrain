class Cycle < ActiveRecord::Base

	belongs_to :project
	has_many :seedtags, dependent: :destroy

	def get_facts
		facts = Array.new
		facts.push("The nutritional content of sprouts is many times greater than the original food value of the seeds and beans from which they sprout.")
		facts.push("Pound for pound, a salad made from a variety of sprouts, compared with the traditional lettuce salad, would cost less than half as much yet provide five times as much protein, six times as much Vitamin C and seven times as much of the B Complex Vitamins.")
		facts.push("Whole dried peas have no Vitamin C, yet when sprouted for 48 hours, provide more Vitamin C (ounce per ounce) than fresh oranges.")
		facts.push("Sprouts save food preparation time since they require no cleaning, peeling or chopping, and can be cooked (if desired) in a mere fraction of the time required for most foods.")
		facts.push("Sprouts have the highest concentration of nutrition per calorie of any food.")
		facts.push("Broccoli sprouts carry potent anti-cancer agents.")
		facts.push("Sprouts are actually freshly germinated edible seeds such as beans, grains and nuts.")
		facts.push("As a 'living' food, Sprouts continue to grow vitamins after being harvested.")
		facts.push("Captain James Cook had his sailors eat sprouts, limes and lemons for their Vitamin C content to aid in curing scurvy.")
		facts.push("During WW1 when the United States was concerned about a possible meat shortage, the scientific community advised the government that the consumption of germinated seeds was the best and the cheapest alternative to proteins in meat.")
		facts.push("Sprouts contain an abundance of highly active anti-oxidants that prevent DNA destruction and protect us from the ongoing effects of aging.")
		facts.push("The most powerful enzyme-rich foods are sprouted seeds, grains and legumes. Sprouting increases their enzyme content as much as 43 times more than non-sprouted foods. The enzymes in Sprouts help our body digest the nutrients in our food and boost the life-giving activity in our body.")
		facts.push("Sprouts save food preparation time since they require no cleaning, peeling or chopping, and can be cooked (if desired) in a mere fraction of the time required for most foods.")
		choice = Random.rand(0..(facts.length-1))
		facts[choice]
	end

	def slack_sprout_alert(participant, seeds)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   # :text => "#{participant.email}: Alert from your sprouts!",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "#{participant.email}: Alert from your sprouts!",
										      	:value => "We need water! This is a reminder that you need to rinse us (#{seeds}) in cool water, and place the jars back facing down. If many of the seeds have sprouted, fill the jar with water and scrape off the seed shells that float to the top."}]
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

	def slack_first_alert(participant)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   # :text => "#{participant.email}: Alert from your sprouts!",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "#{participant.email}: Welcome to the start of a cycle!",
										      	:value => "Congrats to making a new cycle! To start, Put enough seeds (1 to 2 tsbsp. or 3 to 4 tsps., approximately 16-30 grams, depending on the seeds), to lightly cover the bottom surface of the upright jar(s). Cover with mesh screen and secure with rubber band. Rinse seeds of dirt and dust. Cover the seeds with about 2-4cm water and soak for a full 6-8 hours or overnight by leaving jars with the mouth up on the drainage tray. "}]
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

	def repeat_alert
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
						#cycle.slack_first_alert(lucky_participant)
					else
						ParticipantMailer.sprout_alert(lucky_participant, @current_seeds, @fact).deliver
						#cycle.slack_sprout_alert(lucky_participant, @current_seeds)
						if (cycle.end == Date.today && Time.now.utc.hour == (cycle.evening_alert.hour - 2))
							current_user = User.find(Project.find(cycle.project_id).user_id)
							ParticipantMailer.cycle_alert(current_user, cycle, cycle.start).deliver
							#cycle.slack_cycle_alert(current_user)
						end
					end
				end
			end
		end
	end
end