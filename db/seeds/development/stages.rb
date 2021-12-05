fnames = ["孤独の", "豊穣の", "天人", "八重の"]
gnames = ["宗教", "楽園", "五衰"]
0.upto(9) do |idx|
  Stage.create(
    name: "#{fnames[idx % 4]} #{gnames[idx % 3]}"
  )
end