using Printf   # Для форматированного вывода в терминал
using CSV      # Для сохранения данных в формате CSV
using DataFrames # Для работы с табличными данными

# Функция разбивает число N на m частей максимально близких по длине

function split_number(N::Integer, m::Integer)
s = string(N) # Преобразуем число в строку для удобства разбиения
len = length(s) # Длина числа (количество цифр)
base_len = div(len, m) # Базовая длина каждой части
remainder = len % m # Остаток от деления — показывает, сколько частей будет длиннее на 1 символ

parts = String[] # Массив для хранения частей числа
idx = 1 # Текущая позиция в строке

for i in 1:m
current_len = base_len + (i <= remainder ? 1 : 0)  # Длина текущей части
push!(parts, s[idx:idx+current_len-1]) # Добавляем часть строки в массив
idx += current_len # Перемещаем указатель
end

return [parse(BigInt, p) for p in parts] # Возвращаем массив BigInt
end

# Сравнивает PQ и N*k и определяет тип совпадения
function compare_pq_nk(pq::String, nk::String)
if pq == nk
return "✅ Полное совпадение"
elseif startswith(nk, first(pq)) && endswith(nk, last(pq))
return "🔄 Совпадают начало и конец"
elseif startswith(nk, first(pq))
return "🔄 Совпадает начало"
elseif endswith(nk, last(pq))
return "🔄 Совпадает конец"
else
return "❌ Нет совпадений"
end
end

# Проверяет гипотезу для одного числа N
function check_hypothesis(N::Integer, m::Integer, k::Integer)
N_str = string(N) # Число N как строка
nk = string(N * k) # Умноженное число как строка

parts = split_number(N, m) # Разбиваем N на m частей
pq_parts = [string(p * k) for p in parts] # Умножаем каждую часть и преобразуем в строку
pq = join(pq_parts) # Объединяем результаты в одно число PQ

result = compare_pq_nk(pq, nk) # Сравниваем PQ и N*k

return (
N = N,
m = m,
k = k,
parts = string(parts),
multiplied_parts = string([p * k for p in parts]),
PQ = pq,
NK = nk,
result = result
)
end

# Запускает проверку гипотезы для диапазона чисел

function run_tests(start_N::Integer, stop_N::Integer, m::Integer, k::Integer)

# Создаём DataFrame для хранения результатов

results_df = DataFrame(
N = BigInt[],
m = Int[],
k = Int[],
parts = String[],
multiplied_parts = String[],
PQ = String[],
NK = String[],
result = String[]
)

# Счётчики для статистики

count_full = 0
count_partial_start = 0
count_partial_end = 0
count_partial_both = 0
count_none = 0

@printf("\n🚀 Запуск проверки гипотезы\n")
@printf("Диапазон: [%d, %d], m = %d, k = %d\n", start_N, stop_N, m, k)

for N in start_N:stop_N

print("\r🔍 Проверка N = $N...")  # Отображаем прогресс в одной строке

res = check_hypothesis(N, m, k)  # Проверяем гипотезу для конкретного N

# Добавляем результат в таблицу
        
push!(results_df, [
res.N
res.m
res.k
res.parts
res.multiplied_parts
res.PQ
res.NK
res.result
])

# Обновляем счётчики

if res.result == "✅ Полное совпадение"
count_full += 1
elseif res.result == "🔄 Совпадают начало и конец"
count_partial_both += 1
elseif res.result == "🔄 Совпадает начало"
count_partial_start += 1
elseif res.result == "🔄 Совпадает конец"
count_partial_end += 1
else
count_none += 1
end
end

println("\n💾 Сохраняю результаты в CSV...")
CSV.write("results.csv", results_df)  # Сохраняем в файл CSV

# Выводим статистику

println("\n📊 Статистика:")
@printf("  ✅ Полных совпадений: %d\n", count_full)
@printf("  🔄 Совпадает начало: %d\n", count_partial_start)
@printf("  🔄 Совпадает конец: %d\n", count_partial_end)
@printf("  🔄 Совпадают начало и конец: %d\n", count_partial_both)
@printf("  ❌ Без совпадений: %d\n", count_none)

println("\n📄 Результаты сохранены в 'results.csv'")
return results_df
end

# Пользовательские параметры

start_N = 10  # начальное значение N
stop_N = 100 # конечное значение N
m = 2 # количество частей
k = 7 # множитель

# Запуск программы
run_tests(start_N, stop_N, m, k)
