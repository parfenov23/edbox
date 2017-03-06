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
      redirect_to superuser_email_notifs_path(params: {error: "save"})
    end

    def update
      find_email_notif.update(params_email_notif)
      redirect_to superuser_email_notifs_path(params: {error: "save"})
    end

    def remove
      find_email_notif.destroy
      redirect_to :back
    end

    def latters
      @files = Dir.glob("#{Rails.root}/app/views/home_mailer/**/*")
    end

    def edit_latters
      @file_name = [params[:dir], params[:id]].compact.join("/")
      @file_path= Dir.glob("#{Rails.root}/app/views/home_mailer/#{@file_name}*").first
      @data_file = File.read(@file_path)
    end

    def update_latters
      @file_name = [params[:dir], params[:id]].compact.join("/")
      @file_path= Dir.glob("#{Rails.root}/app/views/home_mailer/#{@file_name}*").first
      File.open(@file_path, "w") do |f|
        f.write(params[:description])
      end
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
