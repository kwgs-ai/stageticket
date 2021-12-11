fnames = ['佐藤', '鈴木', '高橋', '田中']
gnames = ['太郎', '次郎', '花子']
1.upto(10) do |idx|
  stage = Stage.find(idx)
  0.upto(2) do |idx|
    Actoraccount.create(
      stage_id: stage.id,
      actor_name: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
      actor_ID: '1111',
      password: '1111',
      password_confirmation: '1111'
    )
  end
end
