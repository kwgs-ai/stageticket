titles = %w[金閣寺 泥棒日記 痴人の愛 仮面の告白 天人五衰 春の雪 暁の寺 奔馬 雪国 他人の顔 砂の女 赤と黒 パルムの僧院
            イエスの生涯 沈黙 箱男 オデュッセイア 花のノートルダム 夜と霧の隅で 刺青 嘔吐 マノン・レスコー 八本脚の蝶
            リリィ・シュシュのすべて サロメ ドリアン・グレイの肖像 一月物語]
time = [1, 2]
status = [1, 2, 3]

start = Date.parse('2021/7/30')
final = Date.parse('2023/1/12')

start1 = Date.parse('2022/1/30')
final1 = Date.parse('2023/1/12')
1.upto(9) do |id|
  actor = Actor.find(id)
  category = Category.find(rand(1..4))
  0.upto(2) do |idx|
    st = status[rand(0..2)]
    stage = if st == 1
              Stage.new(
                status: st,
                actor_id: actor.id,
                category_id: category.id,
                title: titles[rand(0...titles.length)],
                text: '見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..',
                date: Random.rand(start1..final1),
                time: time[idx % 2]
              )
            else
              Stage.new(
                status: st,
                actor_id: actor.id,
                category_id: category.id,
                title: titles[rand(0...titles.length)],
                text: '見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..',
                date: Random.rand(start..final),
                time: time[idx % 2]
              )
            end
    stage.save(validate: false)
  end
end
