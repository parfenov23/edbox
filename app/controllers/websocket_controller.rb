class WebsocketController < WebsocketRails::BaseController
  def client_connected
    system_msg :new_message, "client #{client_id} connected"
  end

  def new_user
    connection_store[:user] = { user_name: sanitize(message[:user_name]) }
    broadcast_user_list
  end

end