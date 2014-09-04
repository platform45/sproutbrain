# this scheduler is run by heroku scheduler addon (controlled on heroku dashboard)
# all helper methods were put into cycle.rb
desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
  if (Cycle.first == nil)
  	break
  end
	Cycle.all.each do |cycle|
		p = Participant.where(project_id: cycle.project_id)
		p = cycle.cleanup_participants(p)
		if (cycle.valid_now && p.length > 0)
			@current_seeds = cycle.get_current_seeds(cycle)
			#send email
			lucky_participant = p[Random.rand(0..(p.length-1))]
			@fact = cycle.get_facts
			@current_project = Project.find(cycle.project_id)
			send_slack = Project.find(cycle.project_id).slack_channel != ""
			if (cycle.start == Date.today && Time.now.utc.hour == (cycle.morning_alert.hour - 2))
				ParticipantMailer.first_alert(lucky_participant, @fact, cycle).deliver
				cycle.slack_first_alert(lucky_participant, @current_project) if send_slack
			else
				ParticipantMailer.sprout_alert(lucky_participant, @current_seeds, @fact, cycle).deliver
				cycle.slack_sprout_alert(lucky_participant, @current_seeds, @current_project) if send_slack
				if (cycle.end == Date.today && Time.now.utc.hour == (cycle.evening_alert.hour - 2))
					current_user = User.find(Project.find(cycle.project_id).user_id)
					ParticipantMailer.cycle_alert(current_user, cycle, cycle.start, @fact).deliver
					cycle.slack_cycle_alert(current_user, @current_project) if send_slack
				end
			end
		end
	end
end