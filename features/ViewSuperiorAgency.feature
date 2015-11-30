# language: pt

Funcionalidade: Visualizar Órgão Público Superior
  Eu, como usuário,
  Desejo visualizar os órgãos públicos superiores  
  Para saber quais são os órgãos públicos dependentes.

  Dessa forma poderei ver quais órgãos públicos estão ligados ao os órgãos públicos superiores.

Cenario: Visualizar Órgão Público Superior com sucesso
  Após o usuário ter entrado na página do órgão público e 
  clicado no link do órgão público superior,
  ele visualiza o grafo referente aos órgãos públicos associados a ele.

  Dado que eu estou na página do órgão público
  Quando eu clico no link do órgão público superior
  Entao o sistema deve mostrar o grafo do órgão público superior.