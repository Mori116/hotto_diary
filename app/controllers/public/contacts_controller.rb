class Public::ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver
      redirect_to contacts_complete_path
    else
      render :new
    end
  end

  def complete
  end
  # 送信完了画面


  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end

end
