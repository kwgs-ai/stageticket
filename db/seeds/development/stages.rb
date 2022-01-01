fnames = ['孤独の', '豊穣の', '天人', '八重の']
gnames = ['宗教', '楽園', '五衰']
time = [1, 2]
1.upto(9) do |idx|
  actor = Actor.find(idx)
  category = Category.find(rand(1..3))
  0.upto(2) do |idx|
    Stage.create(
      status: rand(1..3),
      actor_id: actor.id,
      category_id: category.id,
      title: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
      text: '見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..',
      date: "#{rand(2021..2023)}-#{rand(1..12)}-#{rand(1..29)}",
      time: time[idx % 2]
    )

  end
end
