fnames = %w[孤独の 豊穣の 天人 八重の 金閣 愛の 夜と霧の]
gnames = %w[宗教 五衰 寺 渇望 隅で]
time = [1, 2]
status = [1, 2, 3]
start = Date.parse('2021/7/30')
final = Date.parse('2023/1/12')
1.upto(9) do |id|
  actor = Actor.find(id)
  category = Category.find(rand(1..3))
  0.upto(2) do |idx|
    stage = Stage.new(
      status: status[idx],
      actor_id: actor.id,
      category_id: category.id,
      title: "#{fnames[id % 7]}#{gnames[id % 5]}",
      text: '見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..',
      date: Random.rand(start..final),
      time: time[idx % 2]
    )
    stage.save(validate: false)
  end
end
