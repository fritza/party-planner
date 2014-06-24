class GuestsController < ApplicationController
  before_action :set_guest, only: [:show, :edit, :update, :destroy]

  # GET /guests
  # GET /guests.json
  def index
    @guests = Guest.all
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
  end

  # GET /guests/new
  def new
    @guest = Guest.new
  end

  # GET /guests/1/edit
  def edit
  end

  # POST /guests
  # POST /guests.json
  def create
    @guest = Guest.new(guest_params)

    respond_to do |format|
      if @guest.save
        format.html { redirect_to @guest, notice: 'Guest was successfully created.' }
        format.json { render :show, status: :created, location: @guest }
      else
        format.html { render :new }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
    respond_to do |format|
      if @guest.update(guest_params)
        format.html { redirect_to @guest, notice: 'Guest was successfully updated.' }
        format.json { render :show, status: :ok, location: @guest }
      else
        format.html { render :edit }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to guests_url, notice: 'Guest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def create_from_cnetid
    # TODO: Guest::new_from_cnetid shoud raise if the record
    # does not exist or is not in the proper group.
    # Also, there could be all kinds of neat things you could do
    # if you had a mapping from group ID to an English phrase:
    # a prioritized way to give a name to the user’s "best" organization.
    
    @guest = Guest.new_from_cnetid(params[:cnetid])
    respond_to do |format|
      if ! @guest
       # debugger
        @guest = Guest.new
        @guest.errors.add(:cnetid, "#{params[:cnetid]} doesn't belong to anyone in Web Services.")
#        flash[:notice] = "Nobody in Web Services has the CNetID #{params[:cnetid]}"
        format.html {render :new }
        format.json {render json: nil, status: :unprocessable_entity }
        # FIXME: I’m sure the JSON format is wrong.
        # Including: What do I do for json:, which seems to want an error array?
      elsif @guest && @guest.save
        format.html { render :edit  }
        format.json { render :show, status: :created, location: @guest }
      else
        format.html { render :new }
        # FIXME: There’s no guest, so no errors.
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
#    redirect_to action: 'new'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:name, :email, :rsvp, :party_id)
    end
end
