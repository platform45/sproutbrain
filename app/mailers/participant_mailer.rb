class ParticipantMailer < ActionMailer::Base
  # default from: "no-reply@gmail.com"
  default from: "from@example.com"

  def sprout_alert(participant, seeds, fact)
   	@participant = participant
   	@seeds = seeds
    @fact = fact
   	mail(to: @participant.email, subject: 'Alert from your sprouts!')
  end

  def cycle_alert(user, cycle, start)
  	@user = user
  	@cycle = cycle
  	@start = start
  	mail(to: @user.email, subject: 'Cycle is about to expire...')
  end

  def first_alert(participant, fact)
    @participant = participant
    @fact = fact
    mail(to: @participant.email, subject: 'Welcome to the start of your cycle!')
  end

end