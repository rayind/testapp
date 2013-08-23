class UsersController < ApplicationController
	def index
		username = cookies[:username]
		if username.present?
			password = cookies[:password]
			if password.present?
				@user = User.where(:username => username, :password => password).first
			else
				@user = User.where(:username => username, :password => "").first
			end
			if @user.blank?
				@user = reg_new_guest
			end
		else
				@user = reg_new_guest
		end
		update_time(@user)
		@users = User.where("last_active > ? and password <> \"\"", Time.now.to_i - 300).all
		@guests = User.where("last_active > ? and password = \"\"", Time.now.to_i - 300).all
		json_out = {
			:users => @users.count,
			:guests => @guests.count
		}
		respond_to do |format|
		  format.html
		  format.json{ render :xml => json_out.to_json}
		end
	end

	def update_time(user)
		if user.active_time.blank?
			user.active_time = 0
		end
		if user.last_active.blank? || Time.now.to_i - user.last_active > 300
			user.last_active = Time.now.to_i
		end
		user.active_time = user.active_time + Time.now.to_i - user.last_active
		user.last_active = Time.now.to_i
		user.save
	end

	def reg_new_guest
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		username = ""
		1.upto(16) { |i| username<< chars[rand(chars.size-1)] }
		cookies[:username] = username
		cookies[:password] = "" 
		user = User.new
		user.username = username
		user.password = ""
		user.save
		return user
	end

	def new
		@user = User.new
	end

	def create
		username = params[:user][:username]
		password = params[:user][:password]
		user = User.where(:username => username).first
		if user.blank?
			if password.zise < 4
				flash[:notice] = "short password"
			else
				@user = User.new(params[:user])
				@user.save
				cookies[:username] = @user.username
				cookies[:password] = @user.password
			end
		else
			flash[:notice] = "existed user name"
		end
		redirect_to :action => :index
	end

	def quit
		cookies.delete :username
		cookies.delete :password
		redirect_to :action => :index
	end

	def login_post
		username = params[:user][:username]
		password = params[:user][:password]
		user = User.where(:username => username, :password => password).first
		if user.blank?
			cookies[:username] = ""
			cookies[:password] = ""
			flash[:notice] = "wrong password"
		else
			if user.logins.blank?
				user.logins = 0
			end
			user.logins = user.logins + 1
			cookies[:username] = username
			cookies[:password] = password
		end
		redirect_to :action => :index
	end

	def login
		@user = User.new
	end

end
