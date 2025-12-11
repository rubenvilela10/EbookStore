class UserMailer < ApplicationMailer
  default from: "r.vilela@runtime-revolution.com"

  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Welcome \"#{@user.name}\" to our platform!"
    )
  end
end
