names = %w[春秋 劇団四季 オペラ団 劇団青い鳥 劇団NS オペラ座 劇団はるか 劇団せせらぎ 劇団aozora
           劇団ネット]

1.upto(10) do |idx|
  User.create(
    name: (names[idx]).to_s,
    login_name: '12345',
    password: '1111',
    password_confirmation: '1111'
  )
end
