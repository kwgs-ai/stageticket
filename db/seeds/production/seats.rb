1.upto(26) do |idx|
  stage = Stage.find(idx)
  1.upto(6) do |idx|
    Seat.create(
      stage_id!: stage.id,
      seat_type: "S#{idx}",
      seat_prise: 7000
    )
  end
  1.upto(12) do |idx|
    Seat.create!(
      stage_id: stage.id,
      seat_type: "A#{idx}",
      seat_prise: 5000
    )
  end
  1.upto(12) do |idx|
    Seat.create!(
      stage_id: stage.id,
      seat_type: "B#{idx}",
      seat_prise: 1000
    )
  end
end
already = Stage.where(status: 2)
p already
1.upto(42) do |idx|
  sta = already[idx]
  seat = sta.seats[rand(0...29)]
  reservation = Reservation.find(idx)
    seat.update(
      reservation_id: reservation.id
    )
end
