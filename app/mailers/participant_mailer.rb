class ParticipantMailer < ActionMailer::Base
  default from: "no-reply@gmail.com"

  def welcome_email(participant, seeds)
 	@participant = participant
 	@seeds = seeds
	mail(to: @participant.email, subject: 'Alert from your sprouts!')
  end
end