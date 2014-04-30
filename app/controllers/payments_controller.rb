class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @original_url = params['original_url']
    #@payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create

    name = params['name']
    card_no = params['cardNo']
    expires = params['expires']
    amount = params['amount']
    original_url = params['original_url']

    @response = HTTParty.put(original_url, { body: {"payment" => {"name" => name, "amount" => amount, "cardNo" => card_no, "expires" => expires }}.to_json,
               headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'} } )


     link_to_next = @response['_links'].values.select do |link|
        link['profile'].include?('order')
      end.first
      if !link_to_next || !link_to_next['href']
        raise 'We can not pickup!'
      end
      @link_to_next = link_to_next['href']

    #render text: @response.to_s
    render :show
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params[:payment]
    end
end
