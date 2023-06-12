# Orders Helper
module OrdersHelper
  def pickup_time_options(branch_id)
    set_branch(branch_id)
    start_time = (Time.now + 1.hour).beginning_of_hour
    branch_opening_time = @branch.opening_time
    branch_closing_time = @branch.closing_time
    end_time = start_time.change(hour: branch_closing_time.hour, min: branch_closing_time.min)

    time_options = []
    current_time = start_time

    while current_time <= end_time
      if current_time >= current_time.change(hour: branch_opening_time.hour, min: branch_opening_time.min)
        time_options << [current_time.strftime("%I:%M %p"), current_time.strftime("%H:%M")]
      end
      current_time += 30.minutes
    end

    time_options
  end

  def set_branch(branch_id)
    @branch = Branch.find_by(id: branch_id)
    redirect_to root_path, notice: t("errors.branches.not_found") unless @branch
  end
end
