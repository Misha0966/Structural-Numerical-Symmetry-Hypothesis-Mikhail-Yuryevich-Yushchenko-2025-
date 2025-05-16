using Printf  # Используется для форматированного вывода (например, @printf)
# Функция разбивает число N как строку на m частей 
function split_number_str(N::String, m::Integer)
len = length(N) # Длина строки N
base_len = div(len, m) # Базовая длина каждой части при делении на m
remainder = len % m # Остаток от деления длины N на m

parts = String[] # Массив для хранения частей
idx = 1 # Текущий индекс начала следующей части

for i in 1:m  # Цикл по количеству частей
current_len = base_len + (i <= remainder ? 1 : 0)  # Добавляем +1 к длине первым "remainder" частям
push!(parts, N[idx:idx+current_len-1]) # Добавляем подстроку в массив частей
idx += current_len # Сдвигаем индекс на начало следующей части
end

return parts # Возвращаем массив строковых частей
end

# Умножает часть числа, сохраняя длину
function multiply_preserve_length(part::String, k::Integer)
num = parse(BigInt, part) * k  # Преобразуем строку в BigInt и умножаем на k
result = string(num)  # Обратно преобразуем в строку

# Если результат короче исходной части — дополняем нулями слева
return lpad(result, max(length(part), length(result)), '0')
end

# Проверка гипотезы для одного числа
function check_full_match_for_one_number(N::BigInt, m::Integer, k::Integer)
N_str = string(N)                         # Преобразуем N в строку
    is_full_match = pq_str == nk_str          # Проверяем совпадают ли PQ и NK

    @printf("🔢 N = %s\n", N_str)             # Выводим N
    @printf("📐 m = %d\n", m)                  # Выводим количество частей
    @printf("🧮 k = %d\n", k)                  # Выводим коэффициент умножения

    if is_full_match                          # Если совпадают:
        @printf("🛠 Разбиение:\n")
        for (i, part) in enumerate(parts)     # Перечисляем все части
            @printf("   Часть %d: \"%s\"\n", i, part)
        end
        @printf("➡️ Умноженные части:\n")
        for (i, part) in enumerate(pq_parts)  # Перечисляем умноженные части
            @printf("   Часть %d: \"%s\"\n", i, part)
        end
        @printf("📌 PQ = %s\n", pq_str)
        @printf("📌 NK = %s\n", nk_str)
        @printf("✅ Результат: Полное совпадение найдено!\n")

        filename = "full_match_N$(N_str[1:min(50, length(N_str))]...)_m$m.txt"  # Генерируем имя файла

        open(filename, "w") do io             # Открываем файл на запись
            write(io, "📊 Гипотеза структурной числовой симметрии\n")
            write(io, "=========================================\n")
            write(io, "🔢 N = $N_str\n")
            write(io, "📐 m = $m\n")
            write(io, "🧮 k = $k\n")
            write(io, "-----------------------------------------\n")
            write(io, "🛠 Разбиение:\n")
            for (i, part) in enumerate(parts)
                write(io, "   Часть $i: \"$part\", длина: $(length(part))\n")
            end
            write(io, "➡️ Умноженные части:\n")
            for (i, part) in enumerate(pq_parts)
                write(io, "   Часть $i: \"$part\", длина: $(length(part))\n")
            end
            write(io, "📌 PQ = $pq_str\n")
            write(io, "📌 NK = $nk_str\n")
            write(io, "✅ Результат: Полное совпадение найдено.\n")
            write(io, "=========================================\n")
        end

println("\n📄 Результаты сохранены в файл: $filename")
else # Если нет совпадения:
@printf("❌ Нет совпадений для данного разбиения.\n")
end

return ( # Возвращаем структуру с результатом
N = N,
m = m,
k = k,
PQ = pq_str,
NK = nk_str,
result = is_full_match ? "Полное совпадение" : "Нет совпадения"
    )
end

# Пользовательский раздел
# Пример: N = 99^99999 большое число
println("🔄 Вычисляем N = 99^99999...")
N_bigint = big"99"^big"99999"
m = 2 # количество частей
k = 3 # k — натуральное число

# Запуск
check_full_match_for_one_number(N_bigint, m, k)  # Вызываем основную проверку