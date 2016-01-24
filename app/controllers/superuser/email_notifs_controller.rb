module Superuser
  class EmailNotifsController < SuperuserController

    def index
      @email_notifs = EmailNotif.all
    end

    def edit
      @email_notif = find_email_notif
    end

    def new
      @email_notif = EmailNotif.new
    end

    def create
      EmailNotif.new(params_email_notif).save
      redirect_to superuser_email_notifs_path
    end

    def update
      find_email_notif.update(params_email_notif)
      redirect_to superuser_email_notifs_path
    end

    def remove
      find_email_notif.destroy
      redirect_to :back
    end

    private

    def find_email_notif
      EmailNotif.find(params[:id])
    end

    def params_email_notif
      params.require(:email_notifs).permit(:email)
    end

  end
end
