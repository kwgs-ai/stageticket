stages = Stage.where(status: 2)
1.upto(7) do |idx|
  stage = stages[idx]
  user = User.find(idx)
  0.upto(5) do |idx|
    Reservation.create(
      user_id: user.id,
      stage_id: stage.id
    )
  end
end
