types = ['S', 'A', 'B']
costs = [7000, 5000, 1000]
count = 0
1.upto(26) do |idx|
  stage = Stage.find(idx)
  0.upto(1) do |idx|
    count += 1
    Seat.create(
      reservation_id: count,
      stage_id: stage.id,
      seat_type: (types[idx % 3]).to_s,
      seat_prise: costs[idx % 3]
    )
  end
  0.upto(28) do |idx|
    Seat.create(
      stage_id: stage.id,
      seat_type: (types[idx % 3]).to_s,
      seat_prise: costs[idx % 3]
    )
  end
end
