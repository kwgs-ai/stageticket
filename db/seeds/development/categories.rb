categories = ['恋愛もの', 'お笑い', 'オペラ', '戯曲']

1.upto(10) do |idx|
  Category.create(
    name: "#{categories[idx % 4]}"
  )
end
