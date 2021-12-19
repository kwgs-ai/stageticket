

1.upto(9) do |idx|
  stage = Stage.find(idx)
  user = User.find(idx)
  0.upto(5) do |idx|
    Reservation.create(
      user_id: user.id,
      stage_id: stage.id
    )
  end
end
