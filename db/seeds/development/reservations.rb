1.upto(9) do |idx|
  user = Useraccount.find(idx)
  stage = Stage.find(idx)
  0.upto(2) do |idx|
    Reservation.create(
      useraccount_id: user.id,
      stage_id: stage.id
    )
  end
end
