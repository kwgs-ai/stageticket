fnames = ['孤独の', '豊穣の', '天人', '八重の']
gnames = ['宗教', '楽園', '五衰']
time = ['午前', '午後']
1.upto(9) do |idx|
  actor = Actoraccount.find(idx)
  0.upto(2) do |idx|
  Stage.create(
    actoraccount_id: actor.id,
    title: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
    text: '見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..
見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..見本です..',
    date: "#{rand(2020..2022)}-#{rand(1..12)}-#{rand(1..29)}",
    time: time[idx % 2]
  )

  end
end
