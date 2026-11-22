# Modelagem e parametrização de nanopartículas quirais de cobre (CuNPQ)

**Projeto de conclusão de curso | 2026**

**Pesquisadores principais:** Glauber Nascimento de Oliveira e Lorena Ribeiro Nascimento  
**Colaboradores:** Enzo Januzzi e Caio Matheus Leão Dantas  
**Orientadores:** Felippe Colombari, Valeria Marangoni e Daniel Maragno

> **Status:** projeto em desenvolvimento. Este repositório reúne estruturas e scripts de trabalho; ainda não constitui um fluxo de execução integralmente automatizado ou validado para reprodução independente.

## Sobre o projeto

Este repositório documenta etapas computacionais de **construção, funcionalização, otimização e parametrização de modelos de nanopartículas de cobre**, com ênfase em sistemas contendo **L-cisteína ou D-cisteína**. Uma das aplicações investigadas é a interação desses modelos com a **proteína ligadora de penicilina 2 de *Acinetobacter baumannii* (abPBP2)**, por meio de simulações de dinâmica molecular.

A proposta é estabelecer um fluxo de trabalho que relacione a preparação dos sistemas CuNPQ–cisteína com a análise de propriedades estruturais e de possíveis diferenças de interação entre os sistemas L e D. A presença de ligantes quirais e a geração de modelos enantiomórficos não demonstram, isoladamente, quiralidade estrutural da superfície metálica nem reconhecimento enantiopreferencial pela proteína; essas hipóteses exigem caracterização e comparação controlada.

## Objetivos

- Construir modelos atomísticos de nanopartículas de Cu com dimensões nominais distintas.
- Identificar sítios superficiais e preparar estruturas funcionalizadas com cisteína.
- Explorar procedimentos de relaxação estrutural e cálculos eletrônicos/espectroscópicos.
- Preparar modelos da proteína abPBP2 e dos complexos proteína–nanopartícula.
- Investigar, por dinâmica molecular, estabilidade estrutural, flexibilidade, exposição ao solvente e contatos intermoleculares.
- Comparar sistemas L/D sob condições computacionais equivalentes, considerando limitações dos modelos empregados.

## Estrutura do repositório

| Diretório ou arquivo | Conteúdo |
| --- | --- |
| [`Scripts/Construção_NP.ipynb`](Scripts/Constru%C3%A7%C3%A3o_NP.ipynb) | Construção de modelos de Cu utilizando ASE e construção de Wulff. |
| [`Estruturas_CuNP/`](Estruturas_CuNP/) | Estruturas atomísticas em formato `.xyz`, incluindo modelos de Cu e uma estrutura funcionalizada com L-cisteína. |
| [`Cu_cluster_3nm.xyz`](Cu_cluster_3nm.xyz) | Estrutura de um agregado de Cu com dimensão nominal de aproximadamente 3 nm. |
| [`Scripts/Modelagem-NP/`](Scripts/Modelagem-NP/) | Seleção de sítios, adição de espécies superficiais, montagem com ligantes e execução de cálculos com xTB/sTDA. |
| [`PDBs/`](PDBs/) | Estruturas da abPBP2 em formato PDB, incluindo `7ZG8.pdb` e `AbPBP2_AF2_zinco.pdb`. |
| [`Scripts/montagem/`](Scripts/montagem/) | Scripts para preparação da proteína e montagem dos sistemas com CuNPQ-L/D-Cys. |
| [`Scripts/Dinâmica-Molecular/`](Scripts/Din%C3%A2mica-Molecular/) | Scripts de minimização, aquecimento, equilíbrio e produção, com execução em ambiente HPC/SLURM. |
| [`Analises/`](Analises/) | Scripts para tratamento de trajetórias e cálculos de RMSD, RMSF, raio de giração, SASA e ligações de hidrogênio. |

A documentação adicional das análises encontra-se em [`Analises/README.md`](Analises/README.md).

## Fluxo de trabalho

### 1. Construção dos modelos de Cu

O notebook [`Construção_NP.ipynb`](Scripts/Constru%C3%A7%C3%A3o_NP.ipynb) utiliza a biblioteca **Atomic Simulation Environment (ASE)** e o procedimento de **construção de Wulff** para gerar agregados metálicos a partir de planos cristalográficos e energias superficiais relativas.

Os parâmetros presentes no notebook, como constante de rede, número-alvo de átomos e energias superficiais, devem ser entendidos como **entradas de modelagem**. A escolha desses valores deve ser justificada antes de interpretar a morfologia resultante como representação de uma amostra experimental.

### 2. Funcionalização superficial

Os scripts da pasta [`Scripts/Modelagem-NP/`](Scripts/Modelagem-NP/) contemplam:

- identificação de sítios de adsorção com **ACAT**;
- inserção de átomos de S em posições superficiais selecionadas, respeitando um critério geométrico de separação;
- posicionamento de moléculas de cisteína por meio de ferramentas do **GROMACS**.

A geometria produzida é um **modelo inicial de funcionalização**. A identidade química das espécies superficiais, os estados de protonação, a carga total e a representação das interações Cu–S precisam ser definidos e verificados para os cálculos subsequentes.

### 3. Relaxação e cálculos eletrônicos

Há scripts para relaxação com **xTB**, incluindo opções baseadas em **GFN-FF** e **GFN1-xTB**, e para execução de cálculos com **sTDA/xTB**. A pasta [`Analises/`](Analises/) contém uma descrição inicial do tratamento de dados espectroscópicos, incluindo arquivos `rots.dat` e `spec.dat`.

A interpretação de espectros UV–Vis e ECD calculados depende do método, do tamanho e da composição dos modelos, bem como do tratamento das transições e do alargamento espectral. A disponibilidade de um script não implica, por si só, validação do método para nanopartículas metálicas desse tamanho.

### 4. Preparação dos complexos com abPBP2

Os arquivos em [`PDBs/`](PDBs/) e os scripts em [`Scripts/montagem/`](Scripts/montagem/) dão suporte à preparação da proteína e dos modelos de complexo. O fluxo contempla preparação de topologia, definição de caixa, solvatação e adição de íons.

Para comparar L-Cys e D-Cys, é essencial conferir **a estrutura efetivamente utilizada em cada montagem**: uma reflexão geométrica, por exemplo, não substitui a verificação da estereoquímica dos ligantes e da correspondência entre os modelos. Também devem ser mantidos comparáveis a composição, a cobertura superficial, o estado de protonação, as cargas e as condições iniciais.

### 5. Dinâmica molecular

A pasta [`Scripts/Dinâmica-Molecular/`](Scripts/Din%C3%A2mica-Molecular/) reúne scripts destinados às etapas de:

1. minimização de energia;
2. aquecimento;
3. equilíbrio em condições NPT;
4. produção e continuidade de simulações.

Os scripts utilizam **GROMACS** e, em várias etapas, **SLURM**, com configurações específicas para o ambiente computacional em que foram desenvolvidos. Antes da execução, é necessário revisar os recursos solicitados, a versão do GROMACS, as restrições, os caminhos, os nomes dos arquivos e os parâmetros dos arquivos `.mdp`.

### 6. Tratamento e análise das trajetórias

Os scripts em [`Analises/`](Analises/) incluem:

| Análise | Pergunta investigada |
| --- | --- |
| **RMSD** | Como a estrutura se desvia de uma referência ao longo da trajetória? |
| **RMSF** | Quais átomos ou resíduos exibem maior flutuação posicional? |
| **Raio de giração (Rg)** | Como varia a distribuição espacial da massa da proteína? |
| **SASA** | Como muda a área superficial acessível ao solvente da proteína, da nanopartícula e do complexo? |
| **Ligações de hidrogênio** | Como evoluem as ligações de hidrogênio dentro da proteína e entre grupos selecionados da proteína e da nanopartícula? |

Essas medidas devem ser interpretadas em conjunto com a geometria dos contatos, o comportamento temporal e a variabilidade entre réplicas. **Nenhuma delas, isoladamente, demonstra afinidade, ligação estável ou preferência enantiomérica.**

## Ferramentas utilizadas

O fluxo reúne ferramentas de diferentes etapas de cálculo e preparação:

- **Python / Jupyter Notebook**, **ASE** e **ACAT**: construção e funcionalização de estruturas.
- **xTB** e **sTDA/xTB**: relaxação e cálculos eletrônicos/espectroscópicos.
- **GROMACS**: preparação de sistemas, dinâmica molecular e análises de trajetórias.
- **SLURM**: gerenciamento de tarefas em ambiente de computação de alto desempenho.

As versões e dependências completas ainda precisam ser consolidadas em um arquivo de ambiente ou instruções de instalação reproduzíveis.

## Reprodutibilidade e limitações atuais

**Atenção antes de executar os scripts:**

- Diversos arquivos fazem referência a caminhos locais, diretórios de execução e nomes de entrada definidos para o ambiente original.
- Os arquivos `.mdp`, as topologias e outros insumos referenciados pelos scripts **não estão integralmente disponibilizados neste repositório**.
- Alguns scripts representam versões alternativas ou etapas de desenvolvimento e precisam de revisão antes da execução.
- A construção de modelos L e D requer conferência explícita das estruturas de entrada e das transformações aplicadas.
- Uma análise comparativa entre sistemas deve incluir equivalência de parâmetros, múltiplas réplicas quando pertinente e descrição das incertezas.
- As estruturas e os procedimentos disponibilizados não constituem, por si só, evidência experimental de uma composição, estado de oxidação, quiralidade estrutural ou interação enantiopreferencial.

**Próximas etapas de documentação:** disponibilizar arquivos de parâmetros permitidos para compartilhamento; registrar versões dos programas e configurações; padronizar nomes, caminhos e instruções de execução; identificar entradas e saídas de cada etapa; e acrescentar procedimentos de validação e análise estatística.

## Equipe

| Pesquisadores principais | Perfil acadêmico |
| --- | --- |
| **Glauber Nascimento de Oliveira** | [GitHub](https://github.com/Glaubernaoli) · [Lattes](http://lattes.cnpq.br/0913262665776521) · [LinkedIn](https://www.linkedin.com/in/glauber-naoli/) |
| **Lorena Ribeiro Nascimento** | [GitHub](https://github.com/Lorena881) · [Lattes](http://lattes.cnpq.br/6324363090286730) · [LinkedIn](https://www.linkedin.com/in/lorena-ribeiro-nascimento-7952a930b/) |

**Colaboração:** Enzo Januzzi e Caio Matheus Leão Dantas.  
**Orientação:** Felippe Colombari, Valeria Marangoni e Daniel Maragno.

---

*Este repositório documenta um projeto acadêmico em desenvolvimento. Procedimentos e interpretações devem ser verificados em conjunto com os arquivos de entrada, os registros das simulações e os dados experimentais correspondentes.*
