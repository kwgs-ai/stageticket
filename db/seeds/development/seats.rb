types = ['S', 'A', 'B']
costs = [7000, 5000, 1000]
1.upto(9) do |idx|
  # reservation = Reservation.find(idx)
  stage = Stage.find(idx)
  0.upto(50) do |idx|
    Seat.create(
      # reservation_id: reservation.id,
      stage_id: stage.id,
      seat_type: "#{types[idx % 3]}",
      seat_prise: costs[idx % 3]
    )
  end
end
