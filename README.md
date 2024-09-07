# Gerenciador de Gastos

> Este projeto é um gerenciador de gastos pessoais desenvolvido em Ruby utilizando SQLite. Ele permite registrar gastos, calcular totais, mostrar faturas e marcar faturas como pagas.

### Ajustes e melhorias

O projeto ainda está em desenvolvimento e as próximas atualizações serão voltadas para as seguintes tarefas:

- [x] Registrar novos gastos
- [x] Calcular total de gastos por mês
- [x] Mostrar faturas em aberto, pagas e atrasadas
- [ ] Adicionar funcionalidades de relatórios adicionais
- [ ] Implementar uma interface gráfica

## 💻 Pré-requisitos

Antes de começar, verifique se você atendeu aos seguintes requisitos:

- Você instalou a versão mais recente do Ruby e do SQLite3.
- Você tem uma máquina com Windows, Linux ou macOS. Todos os sistemas operacionais são compatíveis.
- Você leu a [documentação do SQLite3](https://www.sqlite.org/docs.html).

## 🚀 Instalando Gerenciador de Gastos

Para instalar o Gerenciador de Gastos, siga estas etapas:

**Linux e macOS**:
```bash
git clone https://github.com/seu_usuario/gerenciador_de_gastos.git
cd gerenciador_de_gastos
bundle install
ruby main.rb
```
**Windows**:
```bash
git clone https://github.com/seu_usuario/gerenciador_de_gastos.git
cd gerenciador_de_gastos
bundle install
ruby main.rb
```

## ☕ Usando Gerenciador de Gastos

Para usar o Gerenciador de Gastos, siga estas etapas:
```bash
ruby main.rb
```

Você verá um menu com as seguintes opções:

1. **Registrar novo gasto**
- Permite que você insira um novo gasto utilizando um cartão de crédito. Você fornecerá a descrição da compra e o valor, que serão armazenados no banco de dados.
2. **Calcular gastos total**
- Calcula e exibe o total dos gastos registrados para o mês atual. O resultado é salvo em um arquivo de texto com a listagem de cada gasto e o total final.
3. **Mostrar faturas (em aberto, pagas, atrasadas)**
  - Permite que você visualize as faturas de acordo com seu status:
    - **Em aberto**: Faturas que ainda não foram pagas.
    - **Pagas**: Faturas que já foram quitadas.
    - **Atrasadas**: Faturas que estão em aberto e estão vencidas (o critério de atraso é baseado no dia atual).

4. **Pagar fatura**
- Permite que você pague uma fatura específica. Você fornecerá o mês e o ano da fatura que deseja pagar, e se confirmar o pagamento, a fatura será marcada como paga no banco de dados.
5. **Sair**
- Encerra o programa e fecha a conexão com o banco de dados.
