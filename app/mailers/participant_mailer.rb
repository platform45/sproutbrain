class ParticipantMailer < ActionMailer::Base
  default from: "no-reply@gmail.com"


  def sprout_alert(participant, seeds)
 	@participant = participant
 	@seeds = seeds

 	# if @seeds.length == 2
 	# 	@seeds[0] += " and "
 	# elsif @seeds.length > 2
 	# 	1.upto(@seeds.length - 1) do |index|
 	# 		@seeds[index - 1] += ", "
 	# 	end
 	# 	@seeds[@seeds.length - 2] += "and "
 	# end

 	# attachments.inline['banner.jpeg'] = File.read("#{Rails.root}/app/assets/images/banner.jpeg")

	mail(to: @participant.email, subject: 'Alert from your sprouts!')
  end
end