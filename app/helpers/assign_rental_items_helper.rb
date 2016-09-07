module AssignRentalItemsHelper
  def size_calibration(str)
    if str.length >= 10 then
      "10px"
    else
      "14px"
    end
  end
end
