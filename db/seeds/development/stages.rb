fnames = %w[孤独の 豊穣の 天人 八重の]
gnames = %w[宗教 楽園 五衰]
time = [1, 2]
status = [1, 2, 3]
start = Date.parse("2021/7/30")
final = Date.parse("2023/1/12")
1.upto(9) do |idx|
  actor = Actor.find(idx)
  category = Category.find(rand(1..3))
  0.upto(2) do |idx|
    stage = Stage.new(
      status: status[idx],
      actor_id: actor.id,
      category_id: category.id,
      title: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
      text: '見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..',
      date: Random.rand(start..final),
      time: time[idx % 2]
    )
    stage.save(validate:false)
  end
end
