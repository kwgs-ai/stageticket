types = %w[S A A B B]
costs = [7000, 5000, 1000]

1.upto(26) do |idx|
  stage = Stage.find(idx)
  reservation = Reservation.find(idx)

  1.upto(30) do |idx|
    Seat.create(
      stage_id: stage.id,
      seat_type: (types[idx % 5]).to_s,
      seat_prise: costs[idx % 3]
    )
  end
end

1.upto(42) do |idx|
  seat = Seat.find(idx)
  reservation = Reservation.find(idx)
  seat.update(
    reservation_id: reservation.id
  )
end
