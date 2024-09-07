require 'sqlite3'
require 'date'

db = SQLite3::Database.new('gastos.db')
db.execute <<-SQL 
  CREATE TABLE IF NOT EXISTS gastos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mes INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    meioPagamento TEXT NOT NULL,
    descricao TEXT NOT NULL,
    valor REAL NOT NULL,
    status TEXT DEFAULT 'em aberto'
  );
SQL

def registrarGasto(db)
  print "Informe qual cartão de crédito: "
  meioPagamento = gets.chomp
  print "Descrição da compra: "
  descricao = gets.chomp
  print "Valor da compra: R$ "
  valor = gets.chomp.to_f

  agora = DateTime.now
  mes = agora.month
  ano = agora.year
  db.execute('INSERT INTO gastos (mes, ano, meioPagamento, descricao, valor) VALUES (?, ?, ?, ?, ?)', [mes, ano, meioPagamento, descricao, valor])
end

def calcularTotais(db)
  agora = DateTime.now
  mes = agora.month
  ano = agora.year
  gastos = db.execute('SELECT meioPagamento, descricao, valor FROM gastos WHERE mes = ? AND ano = ?', [mes, ano])

  if gastos.empty?
    puts "\nNenhum gasto registrado para #{mes}/#{ano}."
    return
  end

  totalCartao = db.get_first_value('SELECT SUM(valor) FROM gastos WHERE mes = ? AND ano = ?', [mes, ano]) || 0

  arquivoNome = "gastos_#{mes}_#{ano}.txt"
  File.open(arquivoNome, 'w') do |arquivo|
    arquivo.puts "Gastos do mês #{mes}/#{ano}"
    arquivo.puts "-" * 40
    gastos.each do |gasto|
      arquivo.puts "Cartão: #{gasto[0]}, Descrição: #{gasto[1]}, Valor: R$ #{'%.2f' % gasto[2]}"
    end
    arquivo.puts "-" * 40
    arquivo.puts "Total da fatura do cartão de crédito: R$ #{'%.2f' % totalCartao}"
  end
  puts "\nTotal da fatura do cartão de crédito para #{mes}/#{ano}: R$ #{'%.2f' % totalCartao}"
  puts "Arquivo #{arquivoNome} gerado com sucesso."
end

def mostrarFaturas(db)
  puts "\nOpções:\n1. Faturas em aberto\n2. Faturas pagas\n3. Faturas atrasadas"
  opcao = gets.chomp
  agora = DateTime.now
  diaAtual = agora.day

  case opcao
  when "1"
    faturas = db.execute("SELECT mes, ano, SUM(valor) FROM gastos WHERE status = 'em aberto' GROUP BY mes, ano")
    status = 'em aberto'
  when "2"
    faturas = db.execute("SELECT mes, ano, SUM(valor) FROM gastos WHERE status = 'paga' GROUP BY mes, ano")
    status = 'paga'
  when "3"
    faturas = db.execute("SELECT mes, ano, SUM(valor) FROM gastos WHERE status = 'em aberto' AND ? > 7 GROUP BY mes, ano", [diaAtual])
    status = 'atrasada'
  else
    puts "Opção inválida!"
    return
  end

  if faturas.any?
    puts "\nFaturas #{status}:"
    faturas.each do |fatura|
      puts "Mês/Ano: #{fatura[0]}/#{fatura[1]}, Total: R$ #{'%.2f' % fatura[2]}"
    end
  else
    puts "\nNenhuma fatura #{status} encontrada."
  end
end

def pagarFatura(db)
  print "Informe o mês da fatura que deseja pagar (1-12): "
  mes = gets.chomp.to_i
  print "Informe o ano da fatura: "
  ano = gets.chomp.to_i
  totalFatura = db.get_first_value("SELECT SUM(valor) FROM gastos WHERE mes = ? AND ano = ? AND status = 'em aberto'", [mes, ano])

  if totalFatura
    print "Confirma o pagamento da fatura de #{mes}/#{ano} no valor de R$ #{'%.2f' % totalFatura}? (s/n): "
    confirmar = gets.chomp.downcase
    if confirmar == 's'
      db.execute("UPDATE gastos SET status = 'paga' WHERE mes = ? AND ano = ?", [mes, ano])
      puts "Fatura de #{mes}/#{ano} paga com sucesso!"
    else
      puts "Pagamento cancelado."
    end
  else
    puts "Não há faturas em aberto para #{mes}/#{ano}."
  end
end

def main(db)
  loop do
    puts "\nMenu:\n1. Registrar novo gasto\n2. Calcular gastos total\n3. Mostrar faturas (em aberto, pagas, atrasadas)\n4. Pagar fatura\n5. Sair"
    opcao = gets.chomp
    case opcao
    when "1"
      registrarGasto(db)
    when "2"
      calcularTotais(db)
    when "3"
      mostrarFaturas(db)
    when "4"
      pagarFatura(db)
    when "5"
      break
    else
      puts "Opção inválida!"
    end
  end
end

main(db)
db.close