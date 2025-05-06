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

for i in 1:m  # Итерация по каждой из m частей для разбиения числа
current_len = base_len + (i <= remainder ? 1 : 0)  # Длина текущей части
push!(parts, s[idx:idx+current_len-1]) # Добавляем часть строки в массив
idx += current_len # Перемещаем указатель
end

return [parse(BigInt, p) for p in parts] # Возвращаем массив BigInt
end

# Функция сравнивает две строки pq и nk и возвращает тип совпадения
function compare_pq_nk(pq::String, nk::String)
if pq == nk # Полное совпадение строк pq и nk
return "✅ Полное совпадение" 
elseif startswith(nk, first(pq)) && endswith(nk, last(pq)) # Совпадают первый и последний символы
return "🔄 Совпадают начало и конец"
elseif startswith(nk, first(pq)) # Совпадает только первый символ
return "🔄 Совпадает начало"
elseif endswith(nk, last(pq)) # Совпадает только последний символ
return "🔄 Совпадает конец"
else  # Нет никаких совпадений
return "❌ Нет совпадений"
end
end

# Функция для проверки гипотезы для одного числа N
function check_hypothesis(N::Integer, m::Integer, k::Integer)
N_str = string(N) # Число N как строка
nk = string(N * k) # Умноженное число как строка

parts = split_number(N, m) # Разбиваем N на m частей
pq_parts = [string(p * k) for p in parts] # Умножаем каждую часть и преобразуем в строку
pq = join(pq_parts) # Объединяем результаты в одно число PQ

result = compare_pq_nk(pq, nk) # Сравниваем PQ и N*k

return (
N = N, # Исходное число N
m = m, # Количество частей, на которые разбивается N
k = k,  # Натуральный множитель
parts = string(parts),  # Разбиение N на части (в виде строк)
multiplied_parts = string([p * k for p in parts]),  # Умноженные на k части
PQ = pq, # Результат объединения умноженных частей
NK = nk, # Результат умножения всего числа N на k
result = result  # Тип совпадения между PQ и NK
)
end

# Функция которая запускает проверку гипотезы для диапазона чисел
function run_tests(start_N::Integer, stop_N::Integer, m::Integer, k::Integer)

results_df = DataFrame(            # Создаём DataFrame для хранения результатов
N = BigInt[], # Исходное число N
m = Int[], # Количество частей
k = Int[], # Натуральный множитель
parts = String[], # Разбиение N на части (в виде строки)
multiplied_parts = String[], # Умноженные части (в виде строки)
PQ = String[], # Результат объединения умноженных частей
NK = String[], # Результат умножения всего числа N на k
result = String[] # Тип совпадения
)

# Счётчики для подсчёта различных типов совпадений

count_full = 0  # Счётчик полных совпадений
count_partial_start = 0  # Счётчик совпадений в начале
count_partial_end = 0  # Счётчик совпадений в конце
count_partial_both = 0 # Счётчик совпадений и в начале, и в конце
count_none = 0 # Счётчик отсутствия совпадений

# Вывод приветственного сообщения и параметров проверки
@printf("\n🚀 Запуск проверки гипотезы\n")
@printf("Диапазон: [%d, %d], m = %d, k = %d\n", start_N, stop_N, m, k)

for N in start_N:stop_N  # Итерация по всем числам N в заданном диапазоне

print("\r🔍 Проверка N = $N...")  # Отображаем прогресс в одной строке

res = check_hypothesis(N, m, k)  # Проверяем гипотезу для конкретного N

# Добавляем результат в таблицу (DataFrame)        
push!(results_df, [
res.N # Исходное число N
res.m # Количество частей m
res.k # Натуральный множитель k
res.parts  # Разбиение числа N на части (как строка)
res.multiplied_parts # Умноженные части (как строка)
res.PQ  # Результат умножения и соединения частей
res.NK # Результат прямого умножения N * k
res.result  # Тип совпадения
])

# Обновляем счётчики в зависимости от результата сравнения
if res.result == "✅ Полное совпадение"
count_full += 1  # Увеличиваем счётчик полных совпадений
elseif res.result == "🔄 Совпадают начало и конец" 
count_partial_both += 1  # Совпадают начало и конец
elseif res.result == "🔄 Совпадает начало"
count_partial_start += 1  # Совпадает только начало
elseif res.result == "🔄 Совпадает конец"
count_partial_end += 1  # Совпадает только конец
else
count_none += 1  # Нет совпадений
end
end

println("\n💾 Сохраняю результаты в CSV...") # Сохраняем накопленные данные в CSV-файл 
CSV.write("results.csv", results_df) # Записываем DataFrame в файл 'results.csv'

println("\n📊 Статистика:") # Выводим статистику по результатам проверки гипотезы
@printf("  ✅ Полных совпадений: %d\n", count_full)  # Всего полных совпадений
@printf("  🔄 Совпадает начало: %d\n", count_partial_start) # Только начало
@printf("  🔄 Совпадает конец: %d\n", count_partial_end)  # Только конец
@printf("  🔄 Совпадают начало и конец: %d\n", count_partial_both)  # И начало, и конец
@printf("  ❌ Без совпадений: %d\n", count_none)  # Нет никаких совпадений

println("\n📄 Результаты сохранены в 'results.csv'") # Сообщаем пользователю о завершении и месте сохранения файла
return results_df # Возвращаем таблицу с результатами
end

# Пользовательские параметры

start_N = 10  # начальное значение N
stop_N = 100 # конечное значение N
m = 2 # количество частей
k = 7 # множитель

# Запуск программы
run_tests(start_N, stop_N, m, k)
