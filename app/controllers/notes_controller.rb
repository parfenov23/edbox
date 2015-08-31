class NotesController < HomeController
  def index
    @current_user = current_user
    @notes = current_user.notes
  end

  def update
    note = (Note.find(params[:note_id]) rescue Note.new)
    if note.update({user_id: current_user.id, attachment_id: params[:attachment_id], text: params[:note_text]})
      html = render_to_string 'notes/notes_aside_block', :layout => false, :locals => {note: note}
      render text: html
    else
      render json: {success: false}
    end
  end

  def destroy
    note = Note.find(params[:id])
    if note.destroy
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  def info
    return unless params[:note_id].present?
    @note = Note.find(params[:note_id])
    html = render_to_string 'notes/info', :layout => false, :locals => {params: params}
    render text: html
  end

end
