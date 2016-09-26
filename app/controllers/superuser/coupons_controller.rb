module Superuser
  class CouponsController < SuperuserController

    def index
      @coupons = BillingCoupon.all
    end

    def edit
      @coupon = find_coupon
    end

    def new
      @coupon = BillingCoupon.new
    end

    def create
      coupon = BillingCoupon.new(params_coupon)
      coupon.save
      redirect_to edit_superuser_coupon_path(coupon.id, params: {error: "save"})
    end

    def update
      company = find_coupon
      company.update(params_coupon)
      redirect_to :back
    end

    def remove
      find_coupon.destroy
      redirect_to :back
    end

    private

    def find_coupon
      BillingCoupon.find(params[:id])
    end

    def params_coupon
      params.require(:coupon).permit(:title, :price).compact rescue {}
    end
  end
end
