class ParticipantMailer < ActionMailer::Base
  default from: "no-reply@gmail.com"
 
  # def welcome_email(participant)
  #   @participant = participant
  #   # @url  = 'http://example.com/login'
  #   mail(to: @participant.email, subject: 'Welcome!')
  # end




  def welcome_email(participant, seeds)
 	@participant = participant
 	@seeds = seeds
	mail(to: @participant.email, subject: 'Your sprouts are thirsty!')
  end
end