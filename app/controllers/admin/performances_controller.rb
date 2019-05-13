# frozen_string_literal: true

module Admin
  ##
  # This controller is responsible for updating the performance percentage
  #
  class PerformancesController < AdminController
    def show; end

    def new
      @performance = Performance.new
    end

    def create
      @performance = Performance.new

      if @performance.update(performance_params)
        redirect_to admin_performance_path,
                    notice: 'Performance percentage successfully updated'
      else
        render :new
      end
    end

    private

    def performance_params
      params.require(:performance).permit(:percentage)
    end
  end
end
