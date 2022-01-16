already = Stage.where(status: 2)
1.upto(7) do |idx|
  stage = already[rand(0...already.length)]
  user = User.find(idx)
  0.upto(5) do
    Reservation.create(
      user_id: user.id,
      stage_id: stage.id
    )
  end
end
