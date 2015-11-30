
Dado(/^que eu sou usuário$/) do
end

E(/^estou na página inicial do sistema$/) do
end

Quando(/^eu clico em gastos por função$/) do
  	visit functions_path
end

Entao(/^o sistema deve mostrar o gráfico de gastos por função$/) do
  	  find(:id, 'spiderChart')
end
