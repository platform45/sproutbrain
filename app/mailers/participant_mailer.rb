class ParticipantMailer < ActionMailer::Base
  # default from: "no-reply@gmail.com"
  default from: "from@example.com"

  def sprout_alert(participant, seeds)
 	@participant = participant
 	@seeds = seeds
 	mail(to: @participant.email, subject: 'Alert from your sprouts!')
  end

  def cycle_alert(user, cycle, start)
  	@user = user
  	@cycle = cycle
  	@start = start
  	mail(to: @user.email, subject: 'Cycle is about to expire...')
  end

end