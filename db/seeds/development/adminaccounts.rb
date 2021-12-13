fnames = ['佐藤', '鈴木', '高橋', '田中']
gnames = ['太郎', '次郎', '花子']
1.upto(10) do |idx|
  Adminaccount.create(
    admin_name: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
    admin_ID: idx,
    password: '1111',
    password_confirmation: '1111'
  )
end
