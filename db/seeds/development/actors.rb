names = %w[春秋 劇団四季 オペラ団 劇団青い鳥 劇団NS オペラ座 劇団はるか 劇団せせらぎ 劇団あお
           劇団ネット]
lnames = %w[haruaki gekidannshiki operadann gekidannaoitori gekidannNS operaza gekidannharuka gekidannseseragi gekidannao gekidannnetto ]
0.upto(9) do |idx|
    Actor.create(
      name: names[idx],
      login_name: lnames[idx],
      password: '1111',
      password_confirmation: '1111'
    )
end
