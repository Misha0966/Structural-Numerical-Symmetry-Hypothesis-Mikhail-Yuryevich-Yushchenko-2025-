using Printf # Для форматированного вывода (например, @printf)
using CSV # Для записи результатов в CSV-файл
using DataFrames # Для работы с табличными данными
using Base.Threads  # Для параллельных вычислений
using ProgressMeter # Для отображения прогресс-бара

# Функция разбивает число N на m частей максимально близких по длине

function split_number_str(N::Integer, m::Integer)
s = string(N) # Преобразуем число N в строку
len = length(s) # Длина числа как строки
base_len = div(len, m) # Базовая длина каждой части
remainder = len % m # Остаток от деления — определяет, где добавить +1

parts = String[] # Массив для хранения строковых частей
idx = 1 # Текущий индекс начала следующей части

for i in 1:m # Цикл по количеству частей
current_len = base_len + (i <= remainder ? 1 : 0)  # Первая часть получает остаток
push!(parts, s[idx:idx+current_len-1]) # Добавляем подстроку в массив
idx += current_len # Сдвигаем индекс на начало следующей части
end

return parts # Возвращаем массив строковых частей
end

# Функция умножает часть числа, сохраняя его длину 
function multiply_preserve_length(part::String, k::Integer)
num = parse(BigInt, part) * k # Преобразуем строку в BigInt и умножаем на k
result = string(num) # Обратно преобразуем в строку

# Если результат короче исходной части — дополняем нулями слева
return lpad(result, length(part), '0')  # Заполняем до оригинальной длины
end

# Сравнивает PQ и NK по началу и концу
function compare_pq_nk(pq::String, nk::String)
 if pq == nk                       # Полное совпадение
return "✅ Полное совпадение"
end

min_len = min(length(pq), length(nk))  # Минимальная длина для сравнения

prefix_match = 0 # Счетчик совпадений в начале
for i in 1:min_len
pq[i] == nk[i] ? prefix_match += 1 : break  # Пока символы совпадают — увеличиваем счетчик
end

suffix_match = 0 # Счетчик совпадений в конце
for i in 1:min_len
pq[end - i + 1] == nk[end - i + 1] ? suffix_match += 1 : break
end

if prefix_match > 0 && suffix_match > 0
return "🔄 Совпадают начало и конец"
elseif prefix_match > 0
return "🔄 Совпадает только начало"
elseif suffix_match > 0
return "🔄 Совпадает только конец"
else
return "❌ Нет совпадений"
end
end

# Проверка гипотезы для одного числа
function check_hypothesis(N::Integer, m::Integer, k::Integer)
N_str = string(N) # Число как строка
nk_str = string(N * k) # N * k как строка

parts_str = split_number_str(N, m) # Разбиваем N на m частей
multiplied_parts_str = [multiply_preserve_length(p, k) for p in parts_str]  # Умножаем каждую часть
pq_str = join(multiplied_parts_str) # Соединяем части обратно

result = compare_pq_nk(pq_str, nk_str) # Сравниваем PQ и NK

return (  # Возвращаем именованный кортеж (NamedTuple) с результатами
N = N, # Исходное число N
m = m, # Количество частей, на которые разбивалось число
k = k, # Множитель, на который умножали части
parts = string(parts_str), # Строковое представление частей (для сохранения в DataFrame)
multiplied_parts = string(multiplied_parts_str),  # Умноженные части как строка
PQ = pq_str, # Результат объединения умноженных частей
NK = nk_str, # Результат умножения всего числа N на k
result = result # Результат сравнения: полное совпадение или тип частичного
)
end

# Параллельная проверка диапазона чисел с прогрессом
function run_tests_parallel(start_N::Integer, stop_N::Integer, m::Integer, k::Integer)
total_numbers = stop_N - start_N + 1 # Считаем общее количество чисел в диапазоне [start_N, stop_N]
results5_df = DataFrame(  # Создаем пустой DataFrame для хранения результатов проверки
 N = Int[], # Исходное число N
 m = Int[], # Количество частей (m)
k = Int[],  # Множитель (k)
parts = String[], # Строковое представление разбиения на части
multiplied_parts = String[], # Умноженные части как строки
PQ = String[], # Результат объединения умноженных частей
NK = String[], # Результат умножения всего числа N на k
result = String[] # Тип совпадения: полное, частичное и т.д.
)

# Инициализируем атомарные счётчики для подсчёта результатов в параллельных потоках
count_full = Atomic{Int}(0) # Полные совпадения
count_partial_start = Atomic{Int}(0) # Совпадения только в начале
count_partial_end = Atomic{Int}(0) # Совпадения только в конце
count_partial_both = Atomic{Int}(0) # Совпадения и в начале, и в конце
count_none = Atomic{Int}(0) # Нет совпадений

# Отображаем прогресс-бар во время обработки диапазона чисел
@showprogress "🚀 Проверяем N ∈ [$start_N, $stop_N], m = $m, k = $k" for N in start_N:stop_N

res = check_hypothesis(N, m, k) # Вызываем функцию проверки гипотезы для текущего числа N
Threads.atomic_add!(count_full, res.result == "✅ Полное совпадение" ? 1 : 0) # Увеличиваем счётчик "Полное совпадение", если результат такой
Threads.atomic_add!(count_partial_start, res.result == "🔄 Совпадает только начало" ? 1 : 0) # Увеличиваем счётчик "Совпадает только начало", если результат такой
Threads.atomic_add!(count_partial_end, res.result == "🔄 Совпадает только конец" ? 1 : 0) # Увеличиваем счётчик "Совпадает только конец", если результат такой
Threads.atomic_add!(count_partial_both, res.result == "🔄 Совпадают начало и конец" ? 1 : 0) # Увеличиваем счётчик "Совпадают и начало, и конец", если результат такой
Threads.atomic_add!(count_none, res.result == "❌ Нет совпадений" ? 1 : 0) # Увеличиваем счётчик "Нет совпадений", если результат такой

push!(results5_df, [ # Добавляем новую строку в DataFrame с результатами
res.N # Исходное число N
res.m # Количество частей (m)
res.k # Множитель (k)
res.parts # Строковое представление разбиения на части
res.multiplied_parts # Умноженные части как строка
res.PQ # Результат объединения умноженных частей
res.NK # Результат умножения всего числа N * k
res.result # Тип совпадения: полное, частичное и т.д.
])
end

# Получаем значения из атомарных счётчиков для вывода статистики
full = count_full[]                   # Полные совпадения: получаем значение из Atomic{Int}
partial_start = count_partial_start[] # Совпадает только начало
partial_end = count_partial_end[]     # Совпадает только конец
partial_both = count_partial_both[]   # Совпадают и начало, и конец
none = count_none[]                   # Нет совпадений вообще

# Сохранение статистики в файл
println("\n💾 Сохраняю результаты в CSV...") # Сообщаем пользователю, что начинаем сохранять результаты в CSV-файл
CSV.write("results5.csv", results5_df) # Записываем DataFrame results5_df в файл 'results5.csv'

open("statistics.txt", "w") do io # Открываем (или создаём) текстовый файл statistics.txt для записи ("w" = write)
write(io, "📊 Гипотеза структурной числовой симметрии\n") # Пишем заголовок отчёта
write(io, "=========================================\n")   # Пишем параметры исследования
write(io, "Диапазон N: [$start_N, $stop_N]\n") # Диапазон проверенных чисел
write(io, "Количество частей m = $m\n") # Количество разбиений
write(io, "Множитель k = $k\n") # Множитель умножения
write(io, "-----------------------------------------\n") # Разделитель
  # Статистика совпадений
    write(io, "  ✅ Полных совпадений: $full\n")            # Полное совпадение PQ == NK
    write(io, "  🔄 Совпадают начало и конец: $partial_both\n")  # Совпадают начало и конец
    write(io, "  🔄 Совпадает только начало: $partial_start\n")  # Только начало совпадает
    write(io, "  🔄 Совпадает только конец: $partial_end\n")     # Только конец совпадает
    write(io, "  ❌ Без совпадений: $none\n")               # Нет совпадений вообще
    write(io, "📄 Результаты по каждому числу — в 'results5.csv'\n")
end  # Файл автоматически закрывается после завершения блока `do io ... end`

# Вывод статистики в терминал (консоль)
println("\n📊 Сводная статистика:") # Выводим заголовок сводной статистики
@printf("  ✅ Полных совпадений: %d\n", full) # Форматированный вывод количества полных совпадений
@printf("  🔄 Совпадают начало и конец: %d\n", partial_both) # Форматированный вывод количества частичных совпадений (начало и конец)
@printf("  🔄 Совпадает только начало: %d\n", partial_start) # Форматированный вывод совпадений только в начале
@printf("  🔄 Совпадает только конец: %d\n", partial_end) # Форматированный вывод совпадений только в конце
@printf("  ❌ Без совпадений: %d\n", none) # Форматированный вывод случаев без совпадений
println("\n📄 Статистика сохранена в 'statistics.txt'") # Сообщаем пользователю, что статистика записана в файл
println("📄 Результаты сохранены в 'results5.csv'") # Сообщаем, что результаты по каждому числу также сохранены

return results5_df # Возвращаем DataFrame с результатами для возможного дальнейшего использования
end

# Параметры пользователя
start_N = 10 # Начальное число диапазона проверки
stop_N = 10000000 # Конечное число диапазона
m = 2 # Число частей, на которые разбивается N
k = 7 # Множитель для умножения частей

# Запуск
run_tests_parallel(start_N, stop_N, m, k)
