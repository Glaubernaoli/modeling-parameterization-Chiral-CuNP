<div align="center">

<img loading="lazy" src="https://github.com/Glaubernaoli/PCD---GenomeIdentifier/assets/172425065/bcfc56a4-b124-4988-88b4-e860cb438f27" width=800>

</div>

<h1 align="center">  Análises
 

 <h4 align="center"> 
     In construction
</h4>

<h2 align="left"> 📈 Parametrização Cu NPQ/Cys </h2>

<div align="justify">

Os arquivos `rots.dat` (Espectro de Linhas) e `spec.dat` (Espectro Alargado) utilizados para obter os gráficos de UV-Vis e ECD são obtidos por meio da linha de comando do script **caminho**.

Notebook em python com as análises da otimização das nanopartículas por cálculos semi-empíricos com o xTB por meio dos gráficos de UV-Vis e ECD gerados com os arquivos  `adicionar nomes arquivos` de energia obtido a partir dos cálculos. Disponíveis na pasta: **caminho**
O notebook:
- Obtem e le os dados dos arquivos `rots.dat` (Espectro de Linhas) e `spec.dat` (Espectro Alargado)
- Transforma os valores numéricos inválidos das colunas em NaN, e realiza um `dropna` para removê-los
- Gera os gráficos com os valores dos Espectros de Linhas  
- Gera os gráficos com o Espectro Alargado

Os gráficos de Espectros de Linhas são gerados a partir das transições sem ajustes por funções mateméticas, assim, são os dados da energia exata calculada em relação a força do oscilador para UV-Vis, ou força rotatória para ECD. Enquanto os gráficos do Espectro Alagardo, em que os dados são ajustados por meio de funções matemáticas de alargamento Gaussiano sobre os dados do espectro de linhas, fornecendo um espectro semelhante ao obtido experimental.


<h2 align="left"> 📊 Dinâmica Molecular </h2>

<div align="justify">

Notebook com as análises sobre os resultados das simulações de dinâmica molecular:
- Gerar trajetórias das estruturas com fit e calcular RMSD, RMSF e PCA com as ferramentas do GROMACS conforme o script **caminho**
- Converter os dados `.xvg` em dataframes com a biblioteca Pandas
(descrever como cada um é calculado)
