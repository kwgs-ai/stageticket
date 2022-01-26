categories = ['恋愛もの', 'お笑い', 'オペラ', 'アクション']

0.upto(3) do |idx|
  Category.create(
    name: (categories[idx]).to_s
  )
end
