class Cycle < ActiveRecord::Base

	belongs_to :project
	has_many :seedtags, dependent: :destroy

	validates :name, presence: true
	validates :start, presence: true
	validates :end, presence: true
	validates :morning_alert, presence: true
	validates :evening_alert, presence: true

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

	def post_slack(project, slack_attachment)
		RestClient.post("https://slack.com/api/chat.postMessage",
    			# this token is generated by a slack user (might expire)
			    {:token => project.slack_token,
			     :channel => "#" + project.slack_channel,
			     :username => "Sproutbrain",
			     :attachments => slack_attachment,
			     :unfurl_links => 1,
			     :icon_url => "http://sr.photos3.fotosearch.com/bthumb/UNC/UNC212/u12257815.jpg",
			     :pretty => "1"
			    })
	end

	def slack_sprout_alert(participant, seeds, project)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   :text => "@#{participant.slack_name}:",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "Alert from your sprouts!",
										      	:value => "We need water! This is a reminder that you need to rinse us (#{seeds}) in cool water, and place the jars back facing down. If many of the seeds have sprouted, fill the jar with water and scrape off the seed shells that float to the top."}]
										}])
		post_slack(project, slack_attachment)
	end

	def slack_cycle_alert(user, project)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   :text => "@#{user.slack_name}:",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "Cycle is about to expire...",
										      	:value => "Your cycle is about to expire! That means you won't be watering us and we're sad:( Please go to www.sproutbrain.com and adjust the start date of your cycle!"}]
										}])

		post_slack(project, slack_attachment)
	end	

	def slack_first_alert(participant, project)
		slack_attachment = JSON.generate([{:fallback => "Sproutbrain notification",
										   :text => "@#{participant.slack_name}:",
										   :color => "#36a64f",
										   :fields =>
										      [{:title => "Welcome to the start of a cycle!"}, 
										       {:title => "Step 1:",
										       	:value => "To start, Put enough seeds (1 to 2 tsbsp. or 3 to 4 tsps., approximately 16-30 grams, depending on the seeds), to lightly cover the bottom surface of the upright jar(s). "}, 
										       {:title => "Step 2:",
										       	:value => "Cover with mesh screen and secure with rubber band. Rinse seeds of dirt and dust."},
										       {:title => "Step 3:",
										       	:value => "Cover the seeds with about 2-4cm water and soak for a full 6-8 hours or overnight by leaving jars with the mouth up on the drainage tray. "}]
										}])
		post_slack(project, slack_attachment)
	end

	def valid_now
		thishour = Time.now.utc.hour
		if (thishour == (self.morning_alert.hour - 2) || thishour == (self.evening_alert.hour - 2))
			if (self.start <= Date.today && self.end >= Date.today)
				return true
			end
		end
		return false
	end

	def get_current_seeds(cycle)
		@current_seeds = Array.new
		if (Seedtag.first != nil && Seedtag.where(cycle_id: cycle.id) != nil)
			Seedtag.where(cycle_id: cycle.id).each do |seedtag|
				s = Seed.find(seedtag.seed_id)
				@current_seeds.push(s.name)
			end
		end
		@current_seeds = @current_seeds.to_sentence
		return @current_seeds
	end

	def cleanup_participants(participants)
		result = Array.new
		participants.each do |participant|
			project = Project.find(self.project_id)
			if project.slack_channel == "" || project.slack_token == ""
				#project doesn't want slack notifications
				result.push(participant) unless participant.email == ""
			else
				#project wants both email and slack
				result.push(participant) unless participant.slack_name == "" || participant.email == ""
			end
		end
		return result
	end
end