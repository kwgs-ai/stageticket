
fnames = ['佐藤', '鈴木', '高橋', '田中','三島','河岸','川島','村上','長谷川','梶']
gnames = ['太郎', '次郎', '花子','龍彦','由紀夫','工房',"晴彦",'由紀','房',"晴"]
lnames = %w[satou suzuki takahashi tanaka mishima kawagishi kawashima murakami hasegawa kaji]

0.upto(9) do |idx|
  User.create!(
    name: "#{fnames[idx]}#{gnames[idx]}",
    login_name: "user#{idx}",
    password: '1111',
    password_confirmation: '1111'
  )
end
