class WebsocketController < WebsocketRails::BaseController
  def client_connected
    WebsocketRails[:channel_name].subscribe connection
    WebsocketRails.users[client_id] = connection
    # system_msg :new_message, "client #{client_id} connected"
  end

  def new_user
    connection_store[:user] = { user: {hash_id: message[:user_name], client_id: client_id} }
    broadcast_user_list
  end

  def broadcast_user_list
    users = all_connect_users
    alert_user
    broadcast_message :user_list, users
  end

  def alert_user
    user = WebsocketRails.users[all_connect_users.first[:user][:client_id]]
    user.send_message :alert, {some: "data"}
  end

  def current_user
    User.find_by_user_key(all_connect_users.select{|u| u[:user][:client_id] == client_id}.last )
  end

  def all_connect_users
    connection_store.collect_all(:user).compact
  end

end