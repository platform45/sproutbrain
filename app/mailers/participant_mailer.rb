class ParticipantMailer < ActionMailer::Base
  default from: "no-reply@gmail.com"

  def welcome_email(participant, seeds)
 	@participant = participant
 	@seeds = seeds
	mail(to: @participant.email, subject: 'Your sprouts are thirsty!')
  end
end