class ParticipantMailer < ActionMailer::Base
  default from: "alert@sproutbrain.com"

  def sprout_alert(participant, seeds, fact, cycle)
   	@participant = participant
   	@seeds = seeds
    @fact = fact
    # @edit_url = "http://localhost:3000/projects/" + "#{cycle.project_id}" + "/cycles/" + "#{cycle.id}" + "/edit"
   	@edit_url = "http://www.sproutbrain.com/projects/" + "#{cycle.project_id}" + "/cycles/" + "#{cycle.id}" + "/edit"
    mail(to: @participant.email, subject: 'Alert from your sprouts!')
  end

  def cycle_alert(user, cycle, start, fact)
  	@user = user
  	@cycle = cycle
  	@start = start
    @fact = fact
    # change localhost to sproutbrain
    # @edit_url = "http://localhost:3000/projects/" + "#{cycle.project_id}" + "/cycles/" + "#{cycle.id}" + "/edit"
  	@edit_url = "http://www.sproutbrain.com/projects/" + "#{cycle.project_id}" + "/cycles/" + "#{cycle.id}" + "/edit"
    mail(to: @user.email, subject: 'Cycle is about to expire...')
  end

  def first_alert(participant, fact, cycle)
    @participant = participant
    @fact = fact
    # @edit_url = "http://localhost:3000/projects/" + "#{cycle.project_id}" + "/cycles/" + "#{cycle.id}" + "/edit"
    @edit_url = "http://www.sproutbrain.com/projects/" + "#{cycle.project_id}" + "/cycles/" + "#{cycle.id}" + "/edit"
    mail(to: @participant.email, subject: 'Welcome to the start of your cycle!')
  end

end