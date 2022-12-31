class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    clubs = BeerClub.all
    m = current_user.memberships.pluck(:beer_club_id)
    @beer_clubs = clubs.select { |club| m.exclude? club.id }
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user
    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_url(@membership.beer_club), notice: "#{@membership.user.username} welcome to the club" }
        format.json { render :show, status: :created, location: @membership.beer_club }
        # redirect_to beer_club_path @membership.beer_club, notice: "moi"
      else
        clubs = BeerClub.all
        m = current_user.memberships.pluck(:beer_club_id)
        @beer_clubs = clubs.select { |club| m.include? club.id }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
    # respond_to do |format|
    # if @membership.save
    #  format.html { redirect_to membership_url(@membership), notice: "Membership was successfully created." }
    # format.json { render :show, status: :created, location: @membership }
    # else
    # format.html { render :new, status: :unprocessable_entity }
    # format.json { render json: @membership.errors, status: :unprocessable_entity }
    # end
    # end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    m = @membership
    name = m.beer_club.name
    m.destroy

    respond_to do |format|
      format.html { redirect_to user_url(current_user), notice: "Membership in #{name} ended." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id)
  end
end
